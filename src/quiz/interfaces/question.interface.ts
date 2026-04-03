export interface SanitizedQuestion {
  id: string;
  questionEn: string;
  questionFr: string | null;
  answers: string[];
  correctIndex: number;
  category: string;
  difficulty: string;
}
