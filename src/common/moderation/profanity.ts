import {
	collapseDuplicatesTransformer,
	DataSet,
	englishDataset,
	englishRecommendedWhitelistMatcherTransformers,
	parseRawPattern,
	RegExpMatcher,
	remapCharactersTransformer,
	resolveConfusablesTransformer,
	resolveLeetSpeakTransformer,
	toAsciiLowerCaseTransformer,
} from 'obscenity';
import { FR_FORBIDDEN_WORDS } from './forbidden-words.fr';

const frenchDiacriticsMap = {
	e: 'éèêë',
	a: 'àâ',
	u: 'ùûü',
	i: 'îï',
	o: 'ôö',
	c: 'ç',
};

const COMBINING_DIACRITICAL_MARKS = /[\u0300-\u036f]/g;

function stripAccents(input: string): string {
	return input
		.normalize('NFD')
		.replace(COMBINING_DIACRITICAL_MARKS, '')
		.toLowerCase();
}

const dataset = new DataSet<{ originalWord: string }>().addAll(englishDataset);
for (const word of FR_FORBIDDEN_WORDS) {
	dataset.addPhrase((phrase) =>
		phrase
			.setMetadata({ originalWord: word })
			.addPattern(parseRawPattern(`|${stripAccents(word)}|`)),
	);
}

const matcher = new RegExpMatcher({
	...dataset.build(),
	blacklistMatcherTransformers: [
		resolveConfusablesTransformer(),
		resolveLeetSpeakTransformer(),
		remapCharactersTransformer(frenchDiacriticsMap),
		toAsciiLowerCaseTransformer(),
		collapseDuplicatesTransformer({ defaultThreshold: 2 }),
	],
	whitelistMatcherTransformers: englishRecommendedWhitelistMatcherTransformers,
});

export function containsForbiddenWord(text: string): boolean {
	return matcher.hasMatch(text);
}
