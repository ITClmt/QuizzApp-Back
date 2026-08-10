import {
	ConflictException,
	ForbiddenException,
	Injectable,
	NotFoundException,
} from '@nestjs/common';
import * as argon2 from 'argon2';
import { ErrorCode, errorBody } from 'src/common/error-codes';
import { Prisma } from 'src/generated/prisma/client';
import { PrismaService } from 'src/prisma/prisma.service';
import { getLevelFromXp, xpForLevel } from 'src/quiz/utils/level.util';
import { isAvatarUnlocked, SELECTABLE_AVATARS } from './constants/avatars';
import { CreateUserDto } from './dto/create-user.dto';
import { UpdateUserDto } from './dto/update-user.dto';

const userSelect = {
	id: true,
	email: true,
	username: true,
	role: true,
	lang: true,
	avatarSlug: true,
	xp: true,
	createdAt: true,
	updatedAt: true,
};

function withLevel<T extends { xp: number }>(user: T) {
	const level = getLevelFromXp(user.xp);
	return {
		...user,
		level,
		xpForCurrentLevel: xpForLevel(level),
		xpForNextLevel: xpForLevel(level + 1),
	};
}

@Injectable()
export class UsersService {
	constructor(private readonly prisma: PrismaService) {}

	private handlePrismaError(error: unknown): never {
		if (
			error instanceof Prisma.PrismaClientKnownRequestError &&
			error.code === 'P2002'
		) {
			throw new ConflictException(
				errorBody(ErrorCode.EMAIL_ALREADY_USED, 'Cet email est déjà utilisé'),
			);
		}
		throw error;
	}

	async findAll(params: { skip?: number; take?: number }) {
		const users = await this.prisma.user.findMany({
			...params,
			select: userSelect,
			orderBy: { createdAt: 'desc' },
		});
		return users.map(withLevel);
	}

	async findById(id: string) {
		const user = await this.prisma.user.findUnique({
			where: { id },
			select: userSelect,
		});
		if (!user)
			throw new NotFoundException(
				errorBody(ErrorCode.USER_NOT_FOUND, 'Utilisateur non trouvé'),
			);
		return withLevel(user);
	}

	/** Catalog + per-user unlock status, mirroring GET /quiz/categories */
	async getAvatarCatalog(id: string) {
		const { xp } = await this.prisma.user.findUniqueOrThrow({
			where: { id },
			select: { xp: true },
		});
		const level = getLevelFromXp(xp);

		return SELECTABLE_AVATARS.map((avatar) => ({
			...avatar,
			unlocked: level >= avatar.unlockLevel,
		}));
	}

	async getUserLang(id: string): Promise<string> {
		const user = await this.prisma.user.findUniqueOrThrow({
			where: { id },
			select: { lang: true },
		});
		return user.lang;
	}

	// ⚠️ Intentionally returns the password hash — needed for auth verification
	async findByEmail(email: string) {
		return this.prisma.user.findUnique({
			where: { email },
		});
	}

	async create(createUserDto: CreateUserDto) {
		const { email, password, username, lang } = createUserDto;

		const hashedPassword = await argon2.hash(password);

		try {
			const user = await this.prisma.user.create({
				data: { email, password: hashedPassword, username, lang },
				select: userSelect,
			});
			return withLevel(user);
		} catch (error) {
			this.handlePrismaError(error);
		}
	}

	async update(
		id: string,
		updateUserDto: UpdateUserDto
	) {
		// Already carries the derived level — no extra query needed for the gate below
		const target = await this.findById(id);

		const data: Prisma.UserUpdateInput = {};
		if (updateUserDto.email !== undefined) data.email = updateUserDto.email;
		if (updateUserDto.username !== undefined)
			data.username = updateUserDto.username;
		if (updateUserDto.lang !== undefined) data.lang = updateUserDto.lang;
		if (updateUserDto.avatarSlug !== undefined) {
			if (
				!isAvatarUnlocked(updateUserDto.avatarSlug, target.level)
			) {
				throw new ForbiddenException(
					errorBody(
						ErrorCode.AVATAR_LOCKED,
						"Cet avatar n'est pas encore débloqué",
					),
				);
			}
			data.avatarSlug = updateUserDto.avatarSlug;
		}

		try {
			const user = await this.prisma.user.update({
				where: { id },
				data,
				select: userSelect,
			});
			return withLevel(user);
		} catch (error) {
			this.handlePrismaError(error);
		}
	}

	async delete(id: string) {
		await this.findById(id);
		await this.prisma.user.delete({ where: { id } });
	}
}
