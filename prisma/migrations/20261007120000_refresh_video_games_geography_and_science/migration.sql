-- Jeux vidéo, Géographie et Sciences et nature refaites pour un public français grand public :
-- 1. retrait des seules questions OpenTriviaDB cassées (réponse fausse ou ambiguë, traduction absurde,
--    doublon, fait daté) ; les questions pointues restent et passent en difficile,
-- 2. difficulté des questions gardées recalée pour ce public,
-- 3. ajout de questions générées (local-scripts/generate-questions.ts), relues.

UPDATE "Question" SET "retiredAt" = CURRENT_TIMESTAMP WHERE "retiredAt" IS NULL AND "sourceId" IN (
    'otd-QXMgb2YgdGhlIHllYXIgMjAyNiwgaG93IG1hbnkga25vd24gbW',
    'otd-SG93IG1hbnkgQ2hhb3MgRW1lcmFsZHMgYXJlIHRoZXJlIGluIH',
    'otd-SG93IG1hbnkgZmxhZ3NoaXAgbW9uc3RlcnMgYXBwZWFyIGluIE',
    'otd-SG93IGxvbmcgd2FzIHRoZSBXb3JsZCBSZWNvcmQgU3BlZWQgUn',
    'otd-SGlkZGVuIGluIHRoZSBmaWxlcyBmb3IgJnF1b3Q7TWFyaW8gS2',
    'otd-SW4gd2hpY2ggc2VyaWVzIG9mIGdhbWVzIGRvIHlvdSBjb2xsZW',
    'otd-SW4gdGhlIEhhbGYtTGlmZSBtb2QgJnF1b3Q7QWZyYWlkIG9mIE',
    'otd-SW4gdGhlIGdhbWUgQ2FsbCBvZiBEdXR5LCB3aGF0IGlzIHRoZS',
    'otd-SW4gJnF1b3Q7UEFZREFZIDImcXVvdDssIHdoYXQgd2VhcG9uIG',
    'otd-SW4gTm8gTWFuJiMwMzk7cyBTa3kgKGFzIG9mIHRoZSBCZXlvbm',
    'otd-SW4gUG9ydGFsLCB0aGUgQ29tcGFuaW9uIEN1YmUmIzAzOTtzIE',
    'otd-SW4gV29ybGQgb2YgV2FyY3JhZnQgTG9yZSwgZm91ciBPbGQgR2',
    'otd-UGhpbCBGaXNoIHdhcyB0aGUgZGVzaWduZXIgb2Ygd2hpY2ggZ2',
    'otd-V2hhdCB0eXBlIG9mIGdlbnJlIGlzIHRoZSBjb250cm92ZXJzaW',
    'otd-V2hhdCB3YXMgdGhlICMxIHNlbGxpbmcgZ2FtZSBvbiBTdGVhbS',
    'otd-V2hhdCB3YXMgdGhlIG5hbWUgb2YgdGhlIGRldmljZSB1c2VkIG',
    'otd-V2hhdCB3YXMgdGhlIHdvcmxkJiMwMzk7cyBmaXJzdCB2aWRlby',
    'otd-V2hhdCBhcmUgdGhlIGNoYW5jZXMgb2YgYmVpbmcgZGVhbHQgYS',
    'otd-V2hhdCBpbmdyZWRpZW50IGlzIE5PVCB1c2VkIHRvIGNyYWZ0IG',
    'otd-V2hhdCBpcyB0aGUgbmFtZSBvZiB0aGUgd29ybGQgdGhhdCB0aG',
    'otd-V2hhdCBpcyB0aGUgbmFtZSBvZiB0aGUgZmluYWwgYm9zcyBpbi',
    'otd-V2hhdCBpcyB0aGUgcGxhbmUgb2YgZXhpc3RlbmNlIGluIE1pY3',
    'otd-V2hhdCBpcyB0aGUgcHVuaXNobWVudCBmb3IgcGxheWluZyBQb3',
    'otd-V2hhdCBpcyB0aGUgdGl0bGUgb2Ygc29uZyBvbiB0aGUgbWFpbi',
    'otd-V2hhdCBQb2smZWFjdXRlO21vbiYjMDM5O3MgQmFzZSBTdGF0IF',
    'otd-V2hpY2ggb2YgdGhlc2UgaXMgTk9UIGEgbWFwIGluY2x1ZGVkIG',
    'otd-V2hpY2ggdGVhbSB3b24gdGhlICZxdW90O1RvbSBDbGFuY3kmIz',
    'otd-V2hpY2ggR3JhbmQgVGhlZnQgQXV0byAoR1RBKSBnYW1lcyBoYX',
    'otd-V2hpY2ggY2l0eSBob3N0ZWQgdGhlIENTOkdPIERyZWFtaGFjay',
    'otd-V2hpY2ggZVNwb3J0cyB0ZWFtIGNhbWUgZmlyc3QgcGxhY2UgaW',
    'otd-V2hvIGlzIGFibGUgdG8gZ3JhYiB0aGUgc3Vydml2b3JzIHdpdG',
    'otd-V2hvIGlzIHRoZSBsZWFkZXIgb2YgVGVhbSBNeXN0aWMgaW4gUG',
    'otd-V2hvIGlzIHRoZSBsZWFkZXIgb2YgVGVhbSBWYWxvciBpbiBQb2',
    'otd-VEYyOiBUaGUgTWVkaWMgd2lsbCBiZSBjcmVkaXRlZCBmb3IgYW',
    'otd-VGhlcmUgYXJlIDIgcGxheWVyIHJvbGVzIGluIFRyb3VibGUgaW',
    'otd-VGhlcmUgYXJlIDYgbGVnZW5kYXJ5IGNhcmRzIGluICZxdW90O0',
    'otd-QWxhc2thIGFuZCBIYXdhaWkgYXJlIHRoZSBvbmx5IFVTIHN0YX',
    'otd-SG93IG1hbnkgdGltZXpvbmVzIGRvZXMgUnVzc2lhIGhhdmU/',
    'otd-SW4gdGhlIDIwMTYgR2xvYmFsIFBlYWNlIEluZGV4IHBvbGwsIG',
    'otd-SW4gMjAxMiB0aGUgR2VybWFuLXNwZWFraW5nIG1pY3Jvc3RhdG',
    'otd-V2hhdCB3YXMgdGhlIG1vc3QgcG9wdWxvdXMgY2l0eSBpbiB0aG',
    'otd-V2hhdCBjaXR5ICBoYXMgdGhlIGJ1c2llc3QgYWlycG9ydCBpbi',
    'otd-V2hhdCBpcyB0aGUgb2ZmaWNpYWwgR2VybWFuIG5hbWUgb2YgdG',
    'otd-V2hhdCBpcyB0aGUgbGFuZCBjb25uZWN0aW5nIE5vcnRoIEFtZX',
    'otd-V2hhdCBpcyB0aGUgbW9zdCBwb3B1bG91cyBNdXNsaW0tbWFqb3',
    'otd-V2hhdCBpcyB0aGUgd29ybGQmIzAzOTtzIHNtYWxsZXN0IGNvdW',
    'otd-V2hhdCBpcyB0aGUgMTV0aCBsZXR0ZXIgb2YgdGhlIEdyZWVrIG',
    'otd-V2hpY2ggaXMgdGhlIGxhcmdlc3QgZnJlc2h3YXRlciBsYWtlIG',
    'otd-V2hpY2ggb2YgdGhlc2UgcGxhY2VzIGlzIGEgbG9jYXRpb24gaW',
    'otd-V2hpY2ggb2YgdGhlc2UgSmFwYW5lc2UgaXNsYW5kcyBpcyB0aG',
    'otd-V2hpY2ggb2YgdGhlc2UgY291bnRyaWVzIGlzIE5PVCB0aGUgb2',
    'otd-V2hpY2ggb2YgdGhlc2UgY291bnRyaWVzIGlzIE5PVCBsb2NhdG',
    'otd-V2hpY2ggY291bnRyeSB3YXMgTk9UIGZvcm1lcmx5IHBhcnQgb2',
    'otd-VGhlcmUgYXJlIG5vIGRlc2VydHMgaW4gRXVyb3BlLg==',
    'otd-VGhlIFNvdXRoZWFzdCBBc2lhbiBpc2xhbmQgb2YgQm9ybmVvIG',
    'otd-VmF0aWNhbiBDaXR5IGlzIGEgY291bnRyeS4=',
    'otd-VmF0aWNhbiBDaXR5LCB0aGUgc21hbGxlc3QgY291bnRyeSBpbi',
    'otd-QWJvdXQgd2hhdCBwZXJjZW50YWdlIG9mIHRoZSBFYXJ0aCYjMD',
    'otd-SG93IG1hbnkgcGxhbmV0cyBhcmUgdGhlcmUgaW4gdGhlIFNvbG',
    'otd-SG93IG1hbnkgcGxhbmV0cyBtYWtlIHVwIG91ciBTb2xhciBTeX',
    'otd-SW4gUHN5Y2hvbG9neSwgd2hpY2ggbmVlZCBhcHBlYXJzIGhpZ2',
    'otd-SWYgeW91IGRpcCBhIGRyeSB0b3dlbCBpbnRvIGEgdHViIGZ1bG',
    'otd-T24gdGhlIEJlYXVmb3J0IFNjYWxlIG9mIHdpbmQgZm9yY2UsIH',
    'otd-V2hhdCBpcyB0aGUgaG90dGVzdCBwbGFuZXQgaW4gdGhlIHNvbG',
    'otd-V2hhdCBvcmdhbmVsbGUgYWlkcyBpbiBzeW50aGVzaXMgb2YgRE',
    'otd-V2hpY2ggb2YgdGhlc2UgdHdvIHBsYXRlcyBhcmUgYmVzdCBrbm');

UPDATE "Question" SET "difficulty" = CASE "sourceId"
    WHEN 'otd-JnF1b3Q7TWluZWNyYWZ0JnF1b3Q7IHdhcyByZWxlYXNlZCBmcm' THEN 'hard'
    WHEN 'otd-JnF1b3Q7U29uaWMgdGhlIEhlZGdlaG9nIDImcXVvdDsgb3JpZ2' THEN 'hard'
    WHEN 'otd-JnF1b3Q7Um9sbGVyY29hc3RlciBUeWNvb24mcXVvdDsgd2FzIH' THEN 'hard'
    WHEN 'otd-JnF1b3Q7UmVzaWRlbnQgRXZpbCA3JnF1b3Q7IGlzIHRoZSBmaX' THEN 'medium'
    WHEN 'otd-JnF1b3Q7VG9tYiBSYWlkZXImcXVvdDsgaWNvbiBMYXJhIENyb2' THEN 'medium'
    WHEN 'otd-JnF1b3Q7VGhlIFBvdGF0byBTYWNrJnF1b3Q7IHdhcyBhIGNvbG' THEN 'hard'
    WHEN 'otd-Q2FwY29tJiMwMzk7cyBzdXJ2aXZhbCBob3Jyb3IgdGl0bGUgRG' THEN 'hard'
    WHEN 'otd-QmlnIHRoZSBDYXQgaXMgYSBwbGF5YWJsZSBjaGFyYWN0ZXIgaW' THEN 'medium'
    WHEN 'otd-QmVmb3JlIGl0JiMwMzk7cyByZWRlc2lnbiBvZiB0aGUgY29tcG' THEN 'hard'
    WHEN 'otd-QnkgaG93IG1hbnkgbWludXRlcyBhcmUgeW91IGxhdGUgdG8gd2' THEN 'hard'
    WHEN 'otd-QW5hIHdhcyBhZGRlZCBhcyBhIG5ldyBoZXJvIGZvciB0aGUgZ2' THEN 'hard'
    WHEN 'otd-QXBlcnR1cmUgU2NpZW5jZSBDRU8gQ2F2ZSBKb2huc29uIGlzIH' THEN 'medium'
    WHEN 'otd-QXMgb2YgRmVicnVhcnkgMjAxOSwgdGhlICZxdW90O0RvbmtleS' THEN 'hard'
    WHEN 'otd-R29yZG9uIEZyZWVtYW4gaXMgc2FpZCB0byBoYXZlIGJ1cm50IG' THEN 'medium'
    WHEN 'otd-R29yZG9uIEZyZWVtYW4sIHRoZSBwcm90YWdvbmlzdCBvZiAmcX' THEN 'medium'
    WHEN 'otd-R3JhbmQgVGhlZnQgQXV0byBWIGlzIHRoZSBmaWZ0ZWVudGggaW' THEN 'easy'
    WHEN 'otd-RG9raSBEb2tpIExpdGVyYXR1cmUgQ2x1YiB3YXMgZGV2ZWxvcG' THEN 'medium'
    WHEN 'otd-RG9ua2V5IEtvbmcgd2FzIG9yaWdpbmFsbHkgc2V0IHRvIGJlIG' THEN 'medium'
    WHEN 'otd-RGF2aWQgQmFzenVja2kgd2FzIGEgY28tZm91bmRlciBvZiBST0' THEN 'hard'
    WHEN 'otd-RGFuZ2Fucm9ucGEgMjogR29vZGJ5ZSBEZXNwYWlyIGZlYXR1cm' THEN 'medium'
    WHEN 'otd-RGV1cyBFeCAoMjAwMCkgZG9lcyBub3QgZmVhdHVyZSB0aGUgV2' THEN 'medium'
    WHEN 'otd-RHJhZ29uRm9yY2UmIzAzOTtzICYjMDM5O1Rocm91Z2ggdGhlIE' THEN 'easy'
    WHEN 'otd-RHVyaW5nIHRoZSBldmVudHMgb2YgSGFsZi1MaWZlOiBPcHBvc2' THEN 'hard'
    WHEN 'otd-Rm9ydG5pdGUgd2FzIG9yaWdpbmFsbHkgaW50ZW5kZWQgdG8gYm' THEN 'easy'
    WHEN 'otd-RmF1c3QgaXMgYSBwbGF5YWJsZSBjaGFyYWN0ZXIgaW4gJnF1b3' THEN 'hard'
    WHEN 'otd-RnJvbSB0aGUgTWVtZSBDdWx0dXJlLCB3aGljaCBNYXJpbyBnYW' THEN 'hard'
    WHEN 'otd-RW5nbGlzaCBuZXcgd2F2ZSBtdXNpY2lhbiBHYXJ5IE51bWFuIG' THEN 'hard'
    WHEN 'otd-RWxsZW4gTWNMYWluLCB0aGUgdm9pY2Ugb2YgR0xhRE9TIGluIH' THEN 'hard'
    WHEN 'otd-RXhjbHVkaW5nIHRoZWlyIGluc3RydWN0b3IsIGhvdyBtYW55IG' THEN 'hard'
    WHEN 'otd-S2lsbGluZyBGbG9vciBzdGFydGVkIGFzIGEgbW9kIGZvciB3aG' THEN 'hard'
    WHEN 'otd-SG93IG1hbnkgbm9ybWFsIGVuZGluZ3MgYXJlIHRoZXJlIGluIE' THEN 'hard'
    WHEN 'otd-SG93IG1hbnkgbWV0YWwgYmFycyBkb2VzIGl0IHRha2UgdG8gc2' THEN 'hard'
    WHEN 'otd-SG93IG1hbnkgc3RhcnMgYXJlIHRoZXJlIHRvIGNvbGxlY3QgaW' THEN 'easy'
    WHEN 'otd-SG93IG1hbnkgcGVybWFuZW50IGNvbXBhbmlvbnMgYXJlIHRoZX' THEN 'hard'
    WHEN 'otd-SG93IG1hbnkgcGxheWFibGUgY2hhcmFjdGVycyBhcmUgdGhlcm' THEN 'hard'
    WHEN 'otd-SG93IG1hbnkgcmVndWxhciBTdW5rZW4gU2VhIFNjcm9sbHMgYX' THEN 'hard'
    WHEN 'otd-SG93IG1hbnkgdGltZXMgZG8geW91IGZpZ2h0IEdpbGdhbWVzaC' THEN 'hard'
    WHEN 'otd-SG93IG1hbnkgem9tYmllcyBuZWVkIHRvIGJlIGtpbGxlZCB0by' THEN 'hard'
    WHEN 'otd-SG93IG1hbnkgTXVkb2tvbnMgYXJlIHJlc2N1YWJsZSBpbiAmcX' THEN 'hard'
    WHEN 'otd-SG93IG1hbnkgY29udHJvbGxlcnMgY291bGQgYSBOaW50ZW5kby' THEN 'easy'
    WHEN 'otd-SG93IG1hbnkgY29waWVzIG9mIHRoZSBub3RvcmlvdXMgRS5ULi' THEN 'medium'
    WHEN 'otd-SG93IG1hbnkgY2FyYm9uIGNhcnMgYXJlIHRoZXJlIGluIEJ1cm' THEN 'hard'
    WHEN 'otd-SG93IG1hbnkgY2xhc3NlcyBhcmUgdGhlcmUgaW4gVGVhbSBGb3' THEN 'easy'
    WHEN 'otd-SG93IG1hbnkgZ2FtZXMgaW4gdGhlIENyYXNoIEJhbmRpY29vdC' THEN 'medium'
    WHEN 'otd-SG93IG1hbnkgZ2FtZXMgYXJlIHRoZXJlIGluIHRoZSAmcXVvdD' THEN 'hard'
    WHEN 'otd-SG93IG1hbnkgZGlmZmVyZW50IG5vdGVzIGlzIHRoZSB0dW5lLC' THEN 'hard'
    WHEN 'otd-SG93IGxvbmcgYXJlIGFsbCB0aGUgY3V0c2NlbmVzIGZyb20gTW' THEN 'medium'
    WHEN 'otd-SGFsZi1MaWZlIGJ5IFZhbHZlIHVzZXMgdGhlIEdvbGRTcmMgZ2' THEN 'medium'
    WHEN 'otd-SnVzdCBDYXVzZSAyIHdhcyBtYWlubHkgc2V0IGluIHdoYXQgZm' THEN 'hard'
    WHEN 'otd-SW4gd2hhdCB5ZWFyIHdhcyAmcXVvdDtBbnRpY2hhbWJlciZxdW' THEN 'hard'
    WHEN 'otd-SW4gd2hhdCB5ZWFyIHdhcyAmcXVvdDtNZXRhbCBHZWFyIFNvbG' THEN 'medium'
    WHEN 'otd-SW4gd2hhdCB5ZWFyIHdhcyB0aGUgb3JpZ2luYWwgU29uaWMgdG' THEN 'easy'
    WHEN 'otd-SW4gd2hhdCB5ZWFyIHdhcyB0aGUgZ2FtZSAmcXVvdDtGVEw6IE' THEN 'hard'
    WHEN 'otd-SW4gd2hhdCB5ZWFyIHdhcyB0aGUgZ2FtZSAmcXVvdDtGYWxsb3' THEN 'medium'
    WHEN 'otd-SW4gd2hhdCB5ZWFyIHdhcyB0aGUgZmlyc3QgJnF1b3Q7TWFzcy' THEN 'medium'
    WHEN 'otd-SW4gd2hhdCB5ZWFyIHdhcyB0aGUgZmlyc3QgZVNwb3J0cyBjb2' THEN 'hard'
    WHEN 'otd-SW4gd2hhdCB5ZWFyIHdhcyBHYXJyeSYjMDM5O3MgTW9kIHJlbG' THEN 'hard'
    WHEN 'otd-SW4gd2hhdCB5ZWFyIHdhcyBIZWFydGhzdG9uZSByZWxlYXNlZD' THEN 'medium'
    WHEN 'otd-SW4gd2hhdCB5ZWFyIHdlcmUgc2NyZWVuc2hvdHMgYWRkZWQgdG' THEN 'hard'
    WHEN 'otd-SW4gd2hhdCB5ZWFyIHdlcmUgYWNoaXZlbWVudHMgYWRkZWQgdG' THEN 'hard'
    WHEN 'otd-SW4gd2hhdCBIYWxmLUxpZmUgZXhwYW5zaW9uIGNhbiB5b3UgZm' THEN 'hard'
    WHEN 'otd-SW4gd2hpY2ggb3JkZXIgZG8geW91IG5lZWQgdG8gaGl0IHNvbW' THEN 'hard'
    WHEN 'otd-SW4gd2hpY2ggbWFsbCBkb2VzICZxdW90O0RlYWQgUmlzaW5nJn' THEN 'medium'
    WHEN 'otd-SW4gd2hpY2ggeWVhciBkaWQgdGhlIG9yaWduYWwgU2ltcyBnYW' THEN 'medium'
    WHEN 'otd-SW4gd2hpY2ggeWVhciBkaWQgdGhlIGZpcnN0IE1vbnN0ZXIgSH' THEN 'hard'
    WHEN 'otd-SW4gd2hpY2ggJnF1b3Q7Q2FsbCBvZiBEdXR5JnF1b3Q7IGdhbW' THEN 'hard'
    WHEN 'otd-SW4gd2hpY2ggTWFyaW8gZ2FtZSBkaWQgdGhlIE1lZ2EgTXVzaH' THEN 'hard'
    WHEN 'otd-SW4gd2hpY2ggY291bnRyeSYjMDM5O3MgdmVyc2lvbiBvZiBIYW' THEN 'hard'
    WHEN 'otd-SW4gd2hpY2ggZ2FtZSBkaWQgdGhlIGNoYXJhY3RlciAmcXVvdD' THEN 'easy'
    WHEN 'otd-SW4gd2hpY2ggZ2FtZSBkb2VzIGEgY2hhcmFjdGVyIHNheSwgJn' THEN 'hard'
    WHEN 'otd-SW4gdGhlICZxdW90O05lcHR1bmlhJnF1b3Q7IHNlcmllcyB3aG' THEN 'hard'
    WHEN 'otd-SW4gdGhlICZxdW90O0hhbG8mcXVvdDsgc2VyaWVzLCB3aGF0IG' THEN 'medium'
    WHEN 'otd-SW4gdGhlICZxdW90O0hhbGYtTGlmZSZxdW90OyBzZXJpZXMsIC' THEN 'hard'
    WHEN 'otd-SW4gdGhlICZxdW90O0NhbGwgT2YgRHV0eTogWm9tYmllcyZxdW' THEN 'hard'
    WHEN 'otd-SW4gdGhlICZxdW90O0RldmlsIE1heSBDcnkmcXVvdDsgZnJhbm' THEN 'medium'
    WHEN 'otd-SW4gdGhlICZxdW90O1Bpa21pbiZxdW90OyBzZXJpZXMsIHdoYX' THEN 'hard'
    WHEN 'otd-SW4gdGhlICZxdW90O1dvcm1zJnF1b3Q7IHNlcmllcyBvZiB2aW' THEN 'medium'
    WHEN 'otd-SW4gdGhlICZxdW90O1MuVC5BLkwuSy5FLlIuJnF1b3Q7IHNlcm' THEN 'hard'
    WHEN 'otd-SW4gdGhlIDE5ODBzLCBhIHNlcnZpY2UgY2FsbGVkIEdhbWVsaW' THEN 'hard'
    WHEN 'otd-SW4gdGhlIDIwMDAgdmlkZW8gZ2FtZSAmcXVvdDtDcmltc29uIF' THEN 'hard'
    WHEN 'otd-SW4gdGhlIDIwMDIgdmlkZW8gZ2FtZSAmcXVvdDtLaW5nZG9tIE' THEN 'hard'
    WHEN 'otd-SW4gdGhlIDIwMTUgUlBHICZxdW90O1VuZGVydGFsZSZxdW90Oy' THEN 'easy'
    WHEN 'otd-SW4gdGhlIE1hc3MgRWZmZWN0IHRyaWxvZ3ksIHdobyBpcyB0aG' THEN 'easy'
    WHEN 'otd-SW4gdGhlIE1hcmlvIHNlcmllcywgd2hpY2ggZ2FtZSBpbnRyb2' THEN 'hard'
    WHEN 'otd-SW4gdGhlIE1vbnN0ZXIgSHVudGVyIFNlcmllcywgaXQgaXMgcG' THEN 'medium'
    WHEN 'otd-SW4gdGhlIE1vbnN0ZXIgSHVudGVyIFNlcmllcywgRy1SYW5rIG' THEN 'medium'
    WHEN 'otd-SW4gdGhlIE1vcnRhbCBLb21iYXQgc2VyaWVzIHRoZSAmcXVvdD' THEN 'medium'
    WHEN 'otd-SW4gdGhlIE5pbnRlbmRvIERTIGdhbWUgJiMwMzk7R2hvc3QgVH' THEN 'hard'
    WHEN 'otd-SW4gdGhlIEFSUEcgJnF1b3Q7UGF0aCBvZiBFeGlsZSwmcXVvdD' THEN 'hard'
    WHEN 'otd-SW4gdGhlIEFuaW1hbCBDcm9zc2luZyBzZXJpZXMsIHdoaWNoIG' THEN 'medium'
    WHEN 'otd-SW4gdGhlIEhhbG8gc2VyaWVzLCB3aGF0IGZsZWV0IHdhcyBUaG' THEN 'hard'
    WHEN 'otd-SW4gdGhlIEhhbG8gc2VyaWVzLCB3aGljaCBlcmEgb2YgU1BBUl' THEN 'medium'
    WHEN 'otd-SW4gdGhlIEhhbGYtTGlmZSBmcmFuY2hpc2UsIHdoYXQgaXMgdG' THEN 'hard'
    WHEN 'otd-SW4gdGhlIEphY2tib3ggcGFydHkgZ2FtZSBNb25zdGVyIFNlZW' THEN 'hard'
    WHEN 'otd-SW4gdGhlIERpc2dhZWEgc2VyaWVzLCBhbnkgY2hhcmFjdGVyIG' THEN 'hard'
    WHEN 'otd-SW4gdGhlIEtpbmdkb20gSGVhcnQgc2VyaWVzIHdobyBwcm92aW' THEN 'hard'
    WHEN 'otd-SW4gdGhlIEZhbGxvdXQ6IE5ldyBWZWdhcyBhZGQtb24gSG9uZX' THEN 'hard'
    WHEN 'otd-SW4gdGhlIEZhbGxvdXQ6IE5ldyBWZWdhcyBhZGQtb24gTG9uZX' THEN 'hard'
    WHEN 'otd-SW4gdGhlIEZhbGxvdXQgc2VyaWVzLCBvbiB3aGljaCBkYXRlIG' THEN 'medium'
    WHEN 'otd-SW4gdGhlIFBBWURBWSBzZXJpZXMsIHdobyBiZXRyYXllZCB0aG' THEN 'hard'
    WHEN 'otd-SW4gdGhlIFBvayZlYWN1dGU7bW9uIHNlcmllcywgd2hpY2ggdH' THEN 'easy'
    WHEN 'otd-SW4gdGhlIFBvcnRhbCBzZXJpZXMsIEFwZXJ0dXJlIFNjaWVuY2' THEN 'hard'
    WHEN 'otd-SW4gdGhlIFJlc2lkZW50IEV2aWwgc2VyaWVzLCBMZW9uIFMuIE' THEN 'easy'
    WHEN 'otd-SW4gdGhlIFlha3V6YSBzZXJpZXMgd2hvIGlzIHRoZSBEcmFnb2' THEN 'medium'
    WHEN 'otd-SW4gdGhlIFN1cGVyIFNtYXNoIEJyb3MuIHNlcmllcywgd2hpY2' THEN 'hard'
    WHEN 'otd-SW4gdGhlIFRlYW0gRm9ydHJlc3MgMiBjYW5vbiwgd2hhdCBkaW' THEN 'medium'
    WHEN 'otd-SW4gdGhlIFZpZGVvIEdhbWUsIEhhbGYtbGlmZSwgd2hhdCB0eX' THEN 'medium'
    WHEN 'otd-SW4gdGhlIG9yaWdpbmFsIERPT00gKDE5OTMpIHdoaWNoIG9mIH' THEN 'medium'
    WHEN 'otd-SW4gdGhlIGdhbWUgc2VyaWVzICZxdW90O1RoZSBMZWdlbmQgb2' THEN 'easy'
    WHEN 'otd-SW4gdGhlIGdhbWUgJnF1b3Q7Q2F2ZSBTdG9yeSwmcXVvdDsgd2' THEN 'hard'
    WHEN 'otd-SW4gdGhlIGdhbWUgJnF1b3Q7REVMVEFSVU5FJnF1b3Q7LCB3aG' THEN 'medium'
    WHEN 'otd-SW4gdGhlIGdhbWUgJnF1b3Q7RGVzdGlueSwmcXVvdDsgdGhlIH' THEN 'medium'
    WHEN 'otd-SW4gdGhlIGdhbWUgJnF1b3Q7U29uaWMgdGhlIEhlZGdlaG9nIC' THEN 'medium'
    WHEN 'otd-SW4gdGhlIGdhbWUgJnF1b3Q7U3VibmF1dGljYSZxdW90Oywgd2' THEN 'hard'
    WHEN 'otd-SW4gdGhlIGdhbWUgJnF1b3Q7U3VibmF1dGljYSZxdW90OywgYS' THEN 'medium'
    WHEN 'otd-SW4gdGhlIGdhbWUgJnF1b3Q7VGhlIFNpbXMmcXVvdDssIGhvdy' THEN 'easy'
    WHEN 'otd-SW4gdGhlIGdhbWUgJnF1b3Q7VW5kZXJ0YWxlJnF1b3Q7LCB3aG' THEN 'easy'
    WHEN 'otd-SW4gdGhlIGdhbWUgQmF0dGxlYmxvY2sgVGhlYXRlciwgd2hhdC' THEN 'hard'
    WHEN 'otd-SW4gdGhlIGdhbWUgRGFuZ2Fucm9ucGE6IEhhcHB5IFRyaWdnZX' THEN 'medium'
    WHEN 'otd-SW4gdGhlIGdhbWUgRGFyayBTb3Vscywgd2hhdCBpcyB0aGUgbm' THEN 'medium'
    WHEN 'otd-SW4gdGhlIGdhbWUgRGVhZCBieSBEYXlsaWdodCwgdGhlIGtpbG' THEN 'medium'
    WHEN 'otd-SW4gdGhlIGdhbWUgRGVzdGlueSwgd2hvIHN1Y2NlZWRlZCBQZX' THEN 'hard'
    WHEN 'otd-SW4gdGhlIGdhbWUgSGFsZi1MaWZlLCB3aGljaCBlbmVteSBpcy' THEN 'medium'
    WHEN 'otd-SW4gdGhlIGdhbWUgT3ZlcndhdGNoLCB3aGljaCBoZXJvIG91dC' THEN 'easy'
    WHEN 'otd-SW4gdGhlIGdhbWUgTnVjbGVhciBUaHJvbmUsIHdoaWNoIGNoYX' THEN 'hard'
    WHEN 'otd-SW4gdGhlIGdhbWUgTnVjbGVhciBUaHJvbmUsIHdoYXQgY2hhcm' THEN 'hard'
    WHEN 'otd-SW4gdGhlIGdhbWUgU29uaWMgRm9yY2VzLCB3aGljaCBvZiB0aG' THEN 'hard'
    WHEN 'otd-SW4gdGhlIGdhbWUgUG9rJmVhY3V0ZTttb24gQ29ucXVlc3QsIG' THEN 'hard'
    WHEN 'otd-SW4gdGhlIGdhbWUgUG9rJmVhY3V0ZTttb24gQ29ucXVlc3QsIH' THEN 'hard'
    WHEN 'otd-SW4gdGhlIGdhbWUgV2FyZnJhbWUsIHdoYXQgaXMgdGhlIGJpcG' THEN 'hard'
    WHEN 'otd-SW4gdGhlIGdhbWUgVGhlIFdvcmxkIEVuZHMgV2l0aCBZb3UsIG' THEN 'hard'
    WHEN 'otd-SW4gdGhlIGFsdGVybmF0ZSB0aW1lbGluZSBpbiBNb3J0YWwgS2' THEN 'medium'
    WHEN 'otd-SW4gdGhlIGJldGEgdmVyc2lvbiBvZiB0aGUgMTk4NiBnYW1lIC' THEN 'hard'
    WHEN 'otd-SW4gdGhlIGluZGllIGZhcm1pbmcgZ2FtZSAmcXVvdDtTdGFyZG' THEN 'medium'
    WHEN 'otd-SW4gdGhlIGNhbm9uICZxdW90O05lcHR1bmlhJnF1b3Q7IGdhbW' THEN 'hard'
    WHEN 'otd-SW4gdGhlIGNvLW9wIHNob290ZXIgUGF5ZGF5IDIsIHdoaWNoIG' THEN 'hard'
    WHEN 'otd-SW4gdGhlIGxvcmUgb2YgdGhlIFBBWURBWSBzZXJpZXMsIHdoaW' THEN 'hard'
    WHEN 'otd-SW4gdGhlIGZpcnN0IExlZnQgNCBEZWFkLCB5b3UgY2FuIHBsYX' THEN 'easy'
    WHEN 'otd-SW4gdGhlIGZpcnN0IGdhbWUgb2YgdGhlIFNseSBDb29wZXIgZn' THEN 'medium'
    WHEN 'otd-SW4gdGhlIGZpZ2h0aW5nIGdhbWUgJnF1b3Q7U2t1bGxnaXJscy' THEN 'hard'
    WHEN 'otd-SW4gdGhlIHBvcHVsYXIgTU9CQSBMZWFndWUgb2YgTGVnZW5kcy' THEN 'medium'
    WHEN 'otd-SW4gdGhlIHdvcmxkIHN0cmF0ZWd5IGdhbWUgJiMwMzk7U2lkIE' THEN 'easy'
    WHEN 'otd-SW4gdGhlIHJ1bGVzIG9mIHRoZSBEYW5nYW5yb25wYSBmcmFuY2' THEN 'hard'
    WHEN 'otd-SW4gdGhlIHJlbWFrZSBvZiAmcXVvdDtSZXNpZGVudCBFdmlsID' THEN 'medium'
    WHEN 'otd-SW4gdGhlIHN1cnZpdmFsIGhvcnJvciBnYW1lLCAmcXVvdDtDcn' THEN 'hard'
    WHEN 'otd-SW4gdGhlIHRpdGxlIG9mIHRoZSBnYW1lICZxdW90O0x1aWdpJi' THEN 'medium'
    WHEN 'otd-SW4gdGhlIHZpZGVvIGdhbWUgc2VyaWVzICZxdW90O0Rpc2dhZW' THEN 'hard'
    WHEN 'otd-SW4gdGhlIHZpZGVvIGdhbWUgJnF1b3Q7Q2xvc2VycyBPbmxpbm' THEN 'hard'
    WHEN 'otd-SW4gdGhlIHZpZGVvIGdhbWUgJnF1b3Q7Qmx1ZSBSZWZsZWN0aW' THEN 'hard'
    WHEN 'otd-SW4gdGhlIHZpZGVvIGdhbWUgJnF1b3Q7U3BsYXRvb24mcXVvdD' THEN 'medium'
    WHEN 'otd-SW4gdGhlIHZpZGVvIGdhbWUgJnF1b3Q7UG9zdGFsIDImcXVvdD' THEN 'hard'
    WHEN 'otd-SW4gdGhlIHZpZGVvIGdhbWUgVGVhbSBGb3J0cmVzcyAyLCB3aG' THEN 'medium'
    WHEN 'otd-SW4gdGhlIHZpZGVvIGdhbWUsIEhhbGYtbGlmZSwgd2hhdCBldm' THEN 'medium'
    WHEN 'otd-SW4gdGhlIHZpZGVvZ2FtZSBCdWxseSwgd2hhdCBpcyB0aGUgcH' THEN 'medium'
    WHEN 'otd-SW4gdmFuaWxsYSBNaW5lY3JhZnQsIHlvdSBjYW4gbWFrZSBhcm' THEN 'easy'
    WHEN 'otd-SW4gJnF1b3Q7Q2FsbCBPZiBEdXR5OiBab21iaWVzJnF1b3Q7LC' THEN 'medium'
    WHEN 'otd-SW4gJnF1b3Q7Q2FsbCBvZiBEdXR5OiBCbGFjayBPcHMgSUlJJn' THEN 'hard'
    WHEN 'otd-SW4gJnF1b3Q7Q2l2aWxpemF0aW9uIDUmcXVvdDssIHdoaWNoIG' THEN 'medium'
    WHEN 'otd-SW4gJnF1b3Q7QSBIYXQgaW4gVGltZSZxdW90Oywgd2hhdCBtdX' THEN 'medium'
    WHEN 'otd-SW4gJnF1b3Q7RGV1cyBFeDogTWFua2luZCBEaXZpZGVkJnF1b3' THEN 'hard'
    WHEN 'otd-SW4gJnF1b3Q7RlRMOiBGYXN0ZXIgVGhhbiBMaWdodCZxdW90Oy' THEN 'hard'
    WHEN 'otd-SW4gJnF1b3Q7RmFsbG91dCA0JnF1b3Q7IHdoaWNoIGZhY3Rpb2' THEN 'medium'
    WHEN 'otd-SW4gJnF1b3Q7RmFsbG91dCA0JnF1b3Q7LCB3aGF0IGlzIHRoZS' THEN 'easy'
    WHEN 'otd-SW4gJnF1b3Q7SGFsbyAyJnF1b3Q7LCB3aGF0IGlzIHRoZSBuYW' THEN 'hard'
    WHEN 'otd-SW4gJnF1b3Q7T3ZlcndhdGNoJnF1b3Q7LCB3aGF0IGlzIHRoZS' THEN 'medium'
    WHEN 'otd-SW4gJnF1b3Q7T3ZlcndhdGNoLCZxdW90OyB3aGF0IGlzIHRoZS' THEN 'easy'
    WHEN 'otd-SW4gJnF1b3Q7TGVhZ3VlIG9mIExlZ2VuZHMmcXVvdDssIHRoZX' THEN 'easy'
    WHEN 'otd-SW4gJnF1b3Q7TW90aGVyIDMsJnF1b3Q7IHRoZSBiaXJkIG9uIH' THEN 'hard'
    WHEN 'otd-SW4gJnF1b3Q7TWFyaW8gJmFtcDsgU29uaWMgYXQgdGhlIE9seW' THEN 'medium'
    WHEN 'otd-SW4gJnF1b3Q7TWluZWNyYWZ0JnF1b3Q7LCBnb2xkIHRvb2xzIG' THEN 'easy'
    WHEN 'otd-SW4gJnF1b3Q7U29uaWMgQWR2ZW50dXJlJnF1b3Q7LCB5b3UgYX' THEN 'medium'
    WHEN 'otd-SW4gJnF1b3Q7U3BhY2UgU3RhdGlvbiAxMyZxdW90OywgIHRoZS' THEN 'medium'
    WHEN 'otd-SW4gJnF1b3Q7U3RhcmJvdW5kJnF1b3Q7LCB0aGUgdHJhY2sgcG' THEN 'hard'
    WHEN 'otd-SW4gJnF1b3Q7U3VwZXIgTWFyaW8gM0QgV29ybGQmcXVvdDssIH' THEN 'hard'
    WHEN 'otd-SW4gJnF1b3Q7U3VwZXIgTWFyaW8gV29ybGQmcXVvdDssIHRoZS' THEN 'hard'
    WHEN 'otd-SW4gJnF1b3Q7UFVCQVRUTEVHUk9VTkRTJnF1b3Q7IHdoaWNoIG' THEN 'medium'
    WHEN 'otd-SW4gJnF1b3Q7UG9rJmVhY3V0ZTttb24gU3VuIGFuZCBNb29uJn' THEN 'medium'
    WHEN 'otd-SW4gJnF1b3Q7UG9ydGFsIDImcXVvdDssIENhdmUgSm9obnNvbi' THEN 'easy'
    WHEN 'otd-SW4gJnF1b3Q7UGhhbnRhc3kgU3RhciBPbmxpbmUgMiZxdW90Oy' THEN 'hard'
    WHEN 'otd-SW4gJnF1b3Q7UGhvZW5peCBXcmlnaHQ6IEFjZSBBdHRvcm5leS' THEN 'medium'
    WHEN 'otd-SW4gJnF1b3Q7UmVzaWRlbnQgRXZpbCAyJnF1b3Q7LCB3aGF0IG' THEN 'hard'
    WHEN 'otd-SW4gJnF1b3Q7UmVzaWRlbnQgRXZpbCAyJnF1b3Q7LCB3aGljaC' THEN 'easy'
    WHEN 'otd-SW4gJnF1b3Q7V2FyaGFtbWVyOiBFbmQgVGltZXMgLSBWZXJtaW' THEN 'easy'
    WHEN 'otd-SW4gJnF1b3Q7VG9ueSBIYXdrJiMwMzk7cyBVbmRlcmdyb3VuZC' THEN 'hard'
    WHEN 'otd-SW4gJnF1b3Q7VGhlIEJpbmRpbmcgb2YgSXNhYWMmcXVvdDssIH' THEN 'medium'
    WHEN 'otd-SW4gJnF1b3Q7VGhlIEVsZGVyIFNjcm9sbHMgMzogTW9ycm93aW' THEN 'hard'
    WHEN 'otd-SW4gJnF1b3Q7VGhlIExlZ2VuZCBvZiBaZWxkYTogT2NhcmluYS' THEN 'easy'
    WHEN 'otd-SW4gJnF1b3Q7VGhlIFNpbXMmcXVvdDsgc2VyaWVzLCB0aGUgbW' THEN 'easy'
    WHEN 'otd-SW4gJnF1b3Q7VW5kZXJ0YWxlJnF1b3Q7LCBob3cgbWFueSBtYW' THEN 'medium'
    WHEN 'otd-SW4gJnF1b3Q7WGVub2JsYWRlIENocm9uaWNsZXMgMiZxdW90Oy' THEN 'medium'
    WHEN 'otd-SW4gJnF1b3Q7WW8hIE5vaWQgMiwmcXVvdDsgVGhlIE5vaWQgY2' THEN 'hard'
    WHEN 'otd-SW4gQ291bnRlci1TdHJpa2U6IEdsb2JhbCBPZmZlbnNpdmUsIH' THEN 'medium'
    WHEN 'otd-SW4gQ291bnRlciBTdHJpa2U6IEdsb2JhbCBPZmZlbnNpdmUsIH' THEN 'medium'
    WHEN 'otd-SW4gQ29EOiBCbGFjayBPcHMgSUlJLCB3aGF0IGlzIHRoZSBuYW' THEN 'medium'
    WHEN 'otd-SW4gQ29vaywgU2VydmUsIERlbGljaW91cyEsIHdoaWNoIGZvb2' THEN 'hard'
    WHEN 'otd-SW4gQ2FsbCBPZiBEdXR5OiBCbGFjayBPcHMgSUksIHdobyBpcy' THEN 'easy'
    WHEN 'otd-SW4gQ2FsbCBvZiBEdXR5OiBNb2Rlcm4gV2FyZmFyZSAyLCBob3' THEN 'easy'
    WHEN 'otd-SW4gQ2FsbCBvZiBEdXR5OiBVbml0ZWQgT2ZmZW5zaXZlLCB3aG' THEN 'hard'
    WHEN 'otd-SW4gR3JhbmQgVGhlZnQgQXV0byBWLCB3aGF0IHdhcyBNaWNoYW' THEN 'medium'
    WHEN 'otd-SW4gR3JhbmQgVGhlZnQgQXV0bzogViwgd2hhdCB3YW50ZWQgbG' THEN 'easy'
    WHEN 'otd-SW4gRG90YSAyLCB3aGF0IGlzIEVhcnRoc2hha2VyJiMwMzk7cy' THEN 'hard'
    WHEN 'otd-SW4gRG90YSAyLCBXcmFpdGggS2luZyB3YXMgcHJldmlvdXNseS' THEN 'medium'
    WHEN 'otd-SW4gRGFuZ2Fucm9ucGE6IFRyaWdnZXIgSGFwcHkgSGF2b2MsIH' THEN 'medium'
    WHEN 'otd-SW4gRGl2aW5pdHk6IE9yaWdpbmFsIFNpbiBJSSwgd2hhdCBpcy' THEN 'medium'
    WHEN 'otd-SW4gRGVhZCBTcGFjZSAyLCB0aGUgJiMwMzk7SGFuZCBDYW5ub2' THEN 'medium'
    WHEN 'otd-SW4gRm9yemEgTW90b3JzcG9ydCA2LCB3aGljaCBvZiB0aGVzZS' THEN 'hard'
    WHEN 'otd-SW4gRmFsbG91dDogTmV3IFZlZ2FzLCB1cG9uIHN0YXJ0aW5nIG' THEN 'hard'
    WHEN 'otd-SW4gRmFsbG91dDogTmV3IFZlZ2FzLCB3aGljaCBvbmUgb2YgdG' THEN 'medium'
    WHEN 'otd-SW4gRml2ZSBOaWdodHMgYXQgRnJlZGR5JiMwMzk7cyAxLCBob3' THEN 'medium'
    WHEN 'otd-SW4gRmluYWwgRmFudGFzeSBYSVYsIHdoYXQgaXMgdGhlIG5hbW' THEN 'hard'
    WHEN 'otd-SW4gS2luZ2RvbSBIZWFydHMsIGhvdyBtYW55IG1lbWJlcnMgZG' THEN 'medium'
    WHEN 'otd-SW4gSGFsZi1MaWZlIDIsIGlmIHlvdSBwbGF5IHRoZSB6b21iaW' THEN 'hard'
    WHEN 'otd-SW4gSGl0bWFuOiBCbG9vZCBNb25leSwgd2hhdCBpcyB0aGUgbm' THEN 'hard'
    WHEN 'otd-SW4gSGVyb2VzIG9mIHRoZSBTdG9ybSwgdGhlIEN1cnNlZCBIb2' THEN 'medium'
    WHEN 'otd-SW4gT3ZlcndhdGNoLCB3aGF0IGlzIEwmdWFjdXRlO2NpbyYjMD' THEN 'hard'
    WHEN 'otd-SW4gT3ZlcndhdGNoLCBob3cgb2xkIGlzIFJlaW5oYXJkdCBXaW' THEN 'hard'
    WHEN 'otd-SW4gTmlnaHQgSW4gVGhlIFdvb2RzLCB3aGVyZSBkb2VzIEdyZW' THEN 'medium'
    WHEN 'otd-SW4gTmVlZCBGb3IgU3BlZWQ6IE1vc3QgV2FudGVkICgyMDA1KS' THEN 'easy'
    WHEN 'otd-SW4gTmVlZCBGb3IgU3BlZWQgTW9zdCBXYW50ZWQgKDIwMDUpLC' THEN 'easy'
    WHEN 'otd-SW4gTmVlZCBmb3IgU3BlZWQ6IE1vc3QgV2FudGVkICgyMDA1KS' THEN 'medium'
    WHEN 'otd-SW4gTmVlZCBmb3IgU3BlZWQ6IFVuZGVyZ3JvdW5kLCB3aGF0IG' THEN 'easy'
    WHEN 'otd-SW4gTW9uc3RlciBIdW50ZXIgR2VuZXJhdGlvbnMsIGd1aWxkIH' THEN 'easy'
    WHEN 'otd-SW4gTW9uc3RlciBIdW50ZXIgR2VuZXJhdGlvbnMsIHdoaWNoIG' THEN 'hard'
    WHEN 'otd-SW4gTWluZWNyYWZ0LCB3aGF0IHR5cGVzIG9mIHNvdW5kIGZpbG' THEN 'hard'
    WHEN 'otd-SW4gTWluZWNyYWZ0OiBKYXZhIEVkaXRpb24sIHdoaWNoIG9mIH' THEN 'hard'
    WHEN 'otd-SW4gU2t5bGFuZGVycyBHaWFudHMsIHdoeSB3YXMgWmFwcyYjMD' THEN 'hard'
    WHEN 'otd-SW4gU2xheSB0aGUgU3BpcmUsIHdoaWNoIG9mIHRoZSBmb2xsb3' THEN 'medium'
    WHEN 'otd-SW4gU3BsYXRvb24sIHdoYXQgaXMgdGhlIGFnZSB0aGF0IGlua2' THEN 'hard'
    WHEN 'otd-SW4gU3RhciBXYXJzOiBSZXB1YmxpYyBDb21tYW5kbyAoMjAwNS' THEN 'hard'
    WHEN 'otd-SW4gUFJPVE9UWVBFIDIsIHdoaWNoIG9mIHRoZSBmb2xsb3dpbm' THEN 'hard'
    WHEN 'otd-SW4gUFJPVE9UWVBFIDIuIHdobyBpcyByZWZlcnJlZCB0byBhcy' THEN 'hard'
    WHEN 'otd-SW4gUG9rJmVhY3V0ZTttb24gU3VuIGFuZCBNb29uLCBhIG1hbG' THEN 'medium'
    WHEN 'otd-SW4gUG9rJmVhY3V0ZTttb24sIEJ1bGJhc2F1ciBpcyB0aGUgb2' THEN 'medium'
    WHEN 'otd-SW4gUG9rZW1vbiBEaWFtb25kLCBQZWFybCBhbmQgUGxhdGludW' THEN 'hard'
    WHEN 'otd-SW4gUG9rZW1vbiBSZWQgJmFtcDsgQmx1ZSwgd2hhdCBpcyB0aG' THEN 'medium'
    WHEN 'otd-SW4gUG9rZW1vbiwgdGhlIGFiaWxpdHkgV29uZGVyIEd1YXJkIG' THEN 'medium'
    WHEN 'otd-SW4gUG9ydGFsIDIsIGhvdyBkaWQgQ0VPIG9mIEFwZXJ0dXJlIF' THEN 'medium'
    WHEN 'otd-SW4gUG9ydGFsIDIsIHdoaWNoIHNvbGFyIHN5c3RlbSBib2R5IG' THEN 'easy'
    WHEN 'otd-SW4gUG9ydGFsIDIsIHRoZSBpY29uaWMgY2hhcmFjdGVyIEdMYU' THEN 'easy'
    WHEN 'otd-SW4gUG9ydGFsLCB3aGF0IGNvbG9yIGlzIHRoZSBJbnRlbGxpZ2' THEN 'hard'
    WHEN 'otd-SW4gUG9ydGFsLCB3aGF0IGNvbG9yIGlzIHRoZSBNb3JhbGl0eS' THEN 'hard'
    WHEN 'otd-SW4gUm9ja2V0IExlYWd1ZSwgeW91IGNhbiBwbGF5IEJhc2tldG' THEN 'easy'
    WHEN 'otd-SW4gUmFpbmJvdyA2IFNpZWdlLCB3aGF0IGlzIEVsYSBhbmQgWm' THEN 'medium'
    WHEN 'otd-SW4gUmVzaWRlbnQgRXZpbCA0LCB0aGUgQ2hpY2FnbyBUeXBld3' THEN 'medium'
    WHEN 'otd-SW4gUnVuZVNjYXBlLCBvbmUgbXVzdCBjb21wbGV0ZSB0aGUgJn' THEN 'hard'
    WHEN 'otd-SW4gUnVzdCwgaG93IG1hbnkgVGltZWQgRXhwbG9zaXZlIENoYX' THEN 'hard'
    WHEN 'otd-SW4gV29ybGQgb2YgV2FyY3JhZnQgbG9yZSwgIGhvdyBtYW55IH' THEN 'hard'
    WHEN 'otd-SW4gV29ybGQgb2YgV2FyY3JhZnQgdGhlIGRlZmF1bHQgVUkgY2' THEN 'hard'
    WHEN 'otd-SW4gV29ybGQgb2YgV2FyY3JhZnQmIzAzOTtzIE1pc3RzIG9mIF' THEN 'medium'
    WHEN 'otd-SW4gV29ybGQgb2YgV2FyY3JhZnQsIHdoaWNoIHJhaWQgaW5zdG' THEN 'medium'
    WHEN 'otd-SW4gV2FyaW9XYXJlOiBTbW9vdGggTW92ZXMsIHdoaWNoIG9uZS' THEN 'hard'
    WHEN 'otd-SW4gVG91aG91IDEyOiBVbmRlZmluZWQgRmFudGFzdGljIE9iam' THEN 'hard'
    WHEN 'otd-SW4gVG91aG91OiBFbWJvZGltZW50IG9mIFNjYXJsZXQgRGV2aW' THEN 'hard'
    WHEN 'otd-SW4gVGhlIEVsZGVyIFNjcm9sbHM6IE9ibGl2aW9uLCB0aGUgaG' THEN 'medium'
    WHEN 'otd-SW4gVGhlIEVsZGVyIFNjcm9sbHMgVjogU2t5cmltLCB3aG8gaX' THEN 'easy'
    WHEN 'otd-SW4gVGhlIFdpdGNoZXIgMywgdGhlIFpvbHRhbiBDaGl2YXkgR3' THEN 'medium'
    WHEN 'otd-SW4gVGVhbSBGb3J0cmVzcyAyLCB0aGUgd2VhcG9uICZxdW90O1' THEN 'hard'
    WHEN 'otd-SW4gVGVhbSBGb3J0cmVzcyAyLCBiZWluZyBkaXNndWlzZWQgYX' THEN 'medium'
    WHEN 'otd-SW4gVGVsbHRhbGUgR2FtZXMmIzAzOTsgJnF1b3Q7VGhlIFdhbG' THEN 'hard'
    WHEN 'otd-SW4gVGVycmFyaWEsIHdoaWNoIG9mIHRoZSBmb2xsb3dpbmcgaX' THEN 'hard'
    WHEN 'otd-SW4gVGVycmFyaWEsIHdoaWNoIG9mIHRoZXNlIGl0ZW1zIGlzIE' THEN 'hard'
    WHEN 'otd-SW4gVGVycmFyaWEsIHdoYXQgZG9lcyB0aGUgV2FsbCBvZiBGbG' THEN 'hard'
    WHEN 'otd-SW4gVGVycmFyaWEsIHlvdSBjYW4gY3JhZnQgdGhlIENlbGwgUG' THEN 'hard'
    WHEN 'otd-SW4gVW50aWwgRGF3biwgYm90aCBjaGFyYWN0ZXJzIFNhbSBhbm' THEN 'medium'
    WHEN 'otd-SW4gVW5kZXJ0YWxlLCB3aGF0JiMwMzk7cyB0aGUgcHJpemUgZm' THEN 'hard'
    WHEN 'otd-SW4gWWFrdXphIDAsIHdoYXQgaXMgdGhlIG9yZGVyIG9mIHRoZS' THEN 'hard'
    WHEN 'otd-SW4gY2FyZWVyIG1vZGUgb2YgJnF1b3Q7TmVlZCBmb3IgU3BlZW' THEN 'easy'
    WHEN 'otd-T24gd2hpY2ggcGxhbmV0IGRvZXMgdGhlIGdhbWUgRnJlZWRvbS' THEN 'hard'
    WHEN 'otd-T24gdGhlIDZ0aCBvZiBKdW5lIDIwMDYsIHdoYXQgd2FzIHRoZS' THEN 'hard'
    WHEN 'otd-T25lIG9mIHRoZSBOaW50ZW5kbyBFbnRlcnRhaW5tZW50IFN5c3' THEN 'hard'
    WHEN 'otd-TmludGVuZG8gc3RhcnRlZCBvdXQgYXMgYSBwbGF5aW5nIGNhcm' THEN 'easy'
    WHEN 'otd-TmludGVuZG8mIzAzOTtzIEx1aWdpIHdhcyBvcmlnaW5hbGx5IG' THEN 'medium'
    WHEN 'otd-TS5VLkcuRS5OLiBpcyB0aGUgbmFtZSBmb3Igd2hhdCB0eXBlIG' THEN 'medium'
    WHEN 'otd-TW9ydGFsIEtvbWJhdCB3YXMgYWxtb3N0IGJhc2VkIG9uIEplYW' THEN 'easy'
    WHEN 'otd-TWlycm9yJiMwMzk7cyBFZGdlIENhdGFseXN0IHRha2VzIHBsYW' THEN 'hard'
    WHEN 'otd-U2V2ZXJhbCBjaGFyYWN0ZXJzIGluICZxdW90O1N1cGVyIE1hcm' THEN 'medium'
    WHEN 'otd-U3VwZXIgTWFyaW8gQnJvcy4gd2FzIHJlbGVhc2VkIGluIDE5OT' THEN 'easy'
    WHEN 'otd-UGlzdG9ucyB3ZXJlIGFkZGVkIHRvIE1pbmVjcmFmdCBpbiBCZX' THEN 'hard'
    WHEN 'otd-UGV0ZXIgTW9seW5ldXggd2FzIHRoZSBmb3VuZGVyIG9mIEJ1bG' THEN 'medium'
    WHEN 'otd-UHN5Y2gtSG9ycm9yICZxdW90O0V0ZXJuYWwgRGFya25lc3M6IF' THEN 'hard'
    WHEN 'otd-Um9sbGVyY29hc3RlciBUeWNvb24gMSBhbmQgMiB3ZXJlIGRldm' THEN 'medium'
    WHEN 'otd-UmluY2V3aW5kIGZyb20gdGhlIDE5OTUgRGlzY3dvcmxkIGdhbW' THEN 'hard'
    WHEN 'otd-UmViZWNjYSBDaGFtYmVycyBkb2VzIG5vdCBhcHBlYXIgaW4gYW' THEN 'hard'
    WHEN 'otd-Unl1amkgU2FrYW1vdG8gaXMgYSBjaGFyYWN0ZXIgZnJvbSBGaW' THEN 'medium'
    WHEN 'otd-V2F0Y2hfRG9ncyAyIGlzIGEgcHJlcXVlbC4=' THEN 'medium'
    WHEN 'otd-V2h5IHdhcyB0aGUgY2hhcmFjdGVyIFRyZXZvciBQaGlsaXBzIG' THEN 'medium'
    WHEN 'otd-V2h5IHdlcmUgb25seSBvbmx5IDMwMCwwMDAgY29waWVzIG9mIF' THEN 'hard'
    WHEN 'otd-V2hhdCB2aWRlbyBnYW1lIGdlbnJlIHdlcmUgdGhlIG9yaWdpbm' THEN 'easy'
    WHEN 'otd-V2hhdCB2aWRlbyBnYW1lIGNvbXBhbnkgZGV2ZWxvcGVkIHRoZS' THEN 'medium'
    WHEN 'otd-V2hhdCB2aWRlbyBnYW1lIGVuZ2luZSBkb2VzIHRoZSB2aWRlb2' THEN 'hard'
    WHEN 'otd-V2hhdCB2YXVsdCBpbiB0aGUgdmlkZW8gZ2FtZSAmcXVvdDtGYW' THEN 'medium'
    WHEN 'otd-V2hhdCB2ZWhpY2xlIGluIFBVQkcgaGFzIHRoZSBoaWdoZXN0IH' THEN 'hard'
    WHEN 'otd-V2hhdCB3YXMgdGhlIE1heGltdW0gTGV2ZWwgaW4gV29ybGQgb2' THEN 'hard'
    WHEN 'otd-V2hhdCB3YXMgdGhlIEZJUlNUIFZhbHZlIGdhbWUgdG8gaGF2ZS' THEN 'hard'
    WHEN 'otd-V2hhdCB3YXMgdGhlIG1haW4gY3VycmVuY3kgaW4gQ2x1YiBQZW' THEN 'easy'
    WHEN 'otd-V2hhdCB3YXMgdGhlIG5hbWUgb2YgdGhlIGNhbmNlbGVkIHByb2' THEN 'medium'
    WHEN 'otd-V2hhdCB3YXMgdGhlIG5hbWUgb2YgdGhlIGNhbmNlbGxlZCBzZX' THEN 'hard'
    WHEN 'otd-V2hhdCB3YXMgdGhlIG9yaWdpbmFsIG5hbWUgb2YgQ3Jhc2ggQm' THEN 'medium'
    WHEN 'otd-V2hhdCB3YXMgdGhlIGZpcnN0IC5oYWNrIGdhbWU/' THEN 'hard'
    WHEN 'otd-V2hhdCB3YXMgdGhlIGZpcnN0ICZxdW90O1RlYW0gRm9ydHJlc3' THEN 'hard'
    WHEN 'otd-V2hhdCB3YXMgdGhlIGZpcnN0IEdhbWUgcmVsZWFzZWQgdXNpbm' THEN 'hard'
    WHEN 'otd-V2hhdCB3YXMgdGhlIGZpcnN0IENhbGwgb2YgRHV0eSBnYW1lIH' THEN 'easy'
    WHEN 'otd-V2hhdCB3YXMgdGhlIGZpcnN0IGdhbWUgaW4gdGhlICZxdW90O0' THEN 'medium'
    WHEN 'otd-V2hhdCB3YXMgdGhlIGZpcnN0IGludGVyYWN0aXZlIG1vdmllIH' THEN 'hard'
    WHEN 'otd-V2hhdCB3YXMgdGhlIGZpcnN0IHdlYXBvbiBwYWNrIGZvciAmcX' THEN 'hard'
    WHEN 'otd-V2hhdCB3YXMgdGhlIHJlbGVhc2UgZGF0ZSBvZiAmcXVvdDtHcm' THEN 'hard'
    WHEN 'otd-V2hhdCB3YXMgRnJhbmsgV2VzdCYjMDM5O3Mgam9iIGluICZxdW' THEN 'medium'
    WHEN 'otd-V2hhdCB3ZXJlIHRoZSBmaXJzdCB0d28gUG9rJmVhY3V0ZTttb2' THEN 'easy'
    WHEN 'otd-V2hhdCB3ZXJlIHRoZSBmaXJzdCB0d28gYmxvY2tzIGluICZxdW' THEN 'hard'
    WHEN 'otd-V2hhdCB5ZWFyIGRpZCB0aGUgZ2FtZSAmcXVvdDtPdmVyd2F0Y2' THEN 'hard'
    WHEN 'otd-V2hhdCB5ZWFyIHdhcyB0aGUgZ2FtZSAmcXVvdDtPdmVyd2F0Y2' THEN 'hard'
    WHEN 'otd-V2hhdCB5ZWFyIHdhcyB0aGUgZ2FtZSBEaXNob25vcmVkIHJlbG' THEN 'hard'
    WHEN 'otd-V2hhdCB5ZWFyIHdhcyB0aGUgZ2FtZSBUZWFtIEZvcnRyZXNzID' THEN 'medium'
    WHEN 'otd-V2hhdCBBbWVyaWNhbiBjaXR5IHdhcyBmZWF0dXJlZCBpbiB0aG' THEN 'hard'
    WHEN 'otd-V2hhdCBDb0QgJnF1b3Q7RGVhdGhzdHJlYWsmcXVvdDsgaXMgb2' THEN 'hard'
    WHEN 'otd-V2hhdCBDUzpHTyBjYXNlIGNvbnRhaW5zIHRoZSBCdXR0ZXJmbH' THEN 'hard'
    WHEN 'otd-V2hhdCBhbmltYWwgaXMgb24gTGluayYjMDM5O3MgcGFqYW1hcy' THEN 'medium'
    WHEN 'otd-V2hhdCBhbmltYWwgaXMgZmVhdHVyZWQgaW4gJnF1b3Q7Qmxvb2' THEN 'easy'
    WHEN 'otd-V2hhdCBhcmUgdGlueSBUaHdvbXBzIGNhbGxlZCBpbiBTdXBlci' THEN 'hard'
    WHEN 'otd-V2hhdCBhcmUgU2FucyBhbmQgUGFweXJ1cyBuYW1lZCBhZnRlci' THEN 'medium'
    WHEN 'otd-V2hhdCBibG9jayBpbiBNaW5lY3JhZnQgaGFzIHRoZSBoaWdoZX' THEN 'hard'
    WHEN 'otd-V2hhdCBjaGFyYWN0ZXIgaXMgTk9UIGFwYXJ0IG9mIHRoZSBHcm' THEN 'easy'
    WHEN 'otd-V2hhdCBjb21wYW55IGRldmVsb3BzIHRoZSBSb2NrIEJhbmQgc2' THEN 'medium'
    WHEN 'otd-V2hhdCBjb2xvciBpcyB0aGUgaWNvbmljIGFyY2FkZSBjaGFyYW' THEN 'medium'
    WHEN 'otd-V2hhdCBjb3VudHJ5IGlzIFNlYW4gTWF0c3VkYSBmcm9tIGluIF' THEN 'hard'
    WHEN 'otd-V2hhdCBkb2VzIElXSEJZRCBzdGFuZCBmb3Igb24gdGhlIHNrdW' THEN 'hard'
    WHEN 'otd-V2hhdCBkZXZpY2UgYWxsb3dzIFRyYWNlciB0byBtYW5pcHVsYX' THEN 'medium'
    WHEN 'otd-V2hhdCBlbmdpbmUgZGlkIHRoZSBvcmlnaW5hbCAmcXVvdDtIYW' THEN 'hard'
    WHEN 'otd-V2hhdCBmb3JtZXIgTU9CQSwgY3JlYXRlZCBieSBXYXlzdG9uZS' THEN 'hard'
    WHEN 'otd-V2hhdCBnYW1lIHdhcyB1c2VkIHRvIGFkdmVydGlzZSBTdGVhbT' THEN 'medium'
    WHEN 'otd-V2hhdCBob3VzZWhvbGQgaXRlbSBtYWtlIHRoZSBjaGFyYWN0ZX' THEN 'medium'
    WHEN 'otd-V2hhdCBpbmdyZWRpZW50cyBhcmUgcmVxdWlyZWQgdG8gbWFrZS' THEN 'medium'
    WHEN 'otd-V2hhdCBpcyB0aGUgaGFyZGVzdCBwb3NzaWJsZSBkaWZmaWN1bH' THEN 'hard'
    WHEN 'otd-V2hhdCBpcyB0aGUgaXRlbSByZXF1aXJlZCB0byBzdW1tb24gdG' THEN 'hard'
    WHEN 'otd-V2hhdCBpcyB0aGUgb25seSBHZW5lcmF0aW9uIElJSSBQb2tlbW' THEN 'hard'
    WHEN 'otd-V2hhdCBpcyB0aGUgbG93ZXN0IGFtb3VudCBvZiBtYXggaGVhbH' THEN 'hard'
    WHEN 'otd-V2hhdCBpcyB0aGUgbGFzdCBuYW1lIG9mIHRoZSBwcmltYXJ5IG' THEN 'hard'
    WHEN 'otd-V2hhdCBpcyB0aGUgbmFtZSBvZiAmcXVvdDtUZWFtIEZvcnRyZX' THEN 'hard'
    WHEN 'otd-V2hhdCBpcyB0aGUgbmFtZSBvZiB0aGUgaXNsYW5kIGludHJvZH' THEN 'hard'
    WHEN 'otd-V2hhdCBpcyB0aGUgbmFtZSBvZiB0aGUgb25seSBmZW1hbGUgJn' THEN 'hard'
    WHEN 'otd-V2hhdCBpcyB0aGUgbmFtZSBvZiB0aGUgbGFyZ2VzdCBwbGFuZX' THEN 'medium'
    WHEN 'otd-V2hhdCBpcyB0aGUgbmFtZSBvZiB0aGUgbWFpbiBpc2xhbmQgaW' THEN 'medium'
    WHEN 'otd-V2hhdCBpcyB0aGUgbmFtZSBvZiB0aGUgbWFpbiBwcm90YWdvbm' THEN 'medium'
    WHEN 'otd-V2hhdCBpcyB0aGUgbmFtZSBvZiB0aGUgcGxheWFibGUgY2hhcm' THEN 'medium'
    WHEN 'otd-V2hhdCBpcyB0aGUgbmFtZSBvZiB0aGUgdmlydXMgdGhhdCBpbm' THEN 'medium'
    WHEN 'otd-V2hhdCBpcyB0aGUgbmFtZSBvZiB0aGUgNC1hcm1lZCBDaGFvcy' THEN 'hard'
    WHEN 'otd-V2hhdCBpcyB0aGUgbmFtZSBvZiB0aGUgOHRoIGluc3RhbGxtZW' THEN 'hard'
    WHEN 'otd-V2hhdCBpcyB0aGUgbmFtZSBvZiB0aGUgQ2l0eSBpbiBTYWludH' THEN 'medium'
    WHEN 'otd-V2hhdCBpcyB0aGUgbmFtZSBvZiB0aGUgY2hpbGQgcGVyZm9ybW' THEN 'hard'
    WHEN 'otd-V2hhdCBpcyB0aGUgbmFtZSBvZiB0aGUgY3JlYXR1cmUgdGhhdC' THEN 'easy'
    WHEN 'otd-V2hhdCBpcyB0aGUgbmFtZSBvZiB0aGUgY3VycmVuY3kgaW4gdG' THEN 'easy'
    WHEN 'otd-V2hhdCBpcyB0aGUgbmFtZSBvZiB0aGUgYWR2ZW50dXJlciB5b3' THEN 'medium'
    WHEN 'otd-V2hhdCBpcyB0aGUgbmFtZSBvZiB0aGUgYWxsaWdhdG9yIGluIF' THEN 'medium'
    WHEN 'otd-V2hhdCBpcyB0aGUgbmFtZSBvZiB0aGUgZ2FtZSBkZXZlbG9wZX' THEN 'medium'
    WHEN 'otd-V2hhdCBpcyB0aGUgbmFtZSBvZiB0aGUgZmlyc3QgbGV2ZWwgaW' THEN 'hard'
    WHEN 'otd-V2hhdCBpcyB0aGUgbmFtZSBvZiB5b3VyIHRlYW0gaW4gU3Rhci' THEN 'medium'
    WHEN 'otd-V2hhdCBpcyB0aGUgbmFtZSBvZiBDcmVhbSB0aGUgUmFiYml0Ji' THEN 'hard'
    WHEN 'otd-V2hhdCBpcyB0aGUgbmFtZSBvZiBKb2VsJiMwMzk7cyBkYXVnaH' THEN 'easy'
    WHEN 'otd-V2hhdCBpcyB0aGUgbmFtZSBvZiBUZWFtIEZvcnRyZXNzIDImIz' THEN 'medium'
    WHEN 'otd-V2hhdCBpcyB0aGUgbW9zdCBleHBlbnNpdmUgd2VhcG9uIGluIE' THEN 'medium'
    WHEN 'otd-V2hhdCBpcyB0aGUgbWF4aW11bSBIUCBpbiBUZXJyYXJpYT8=' THEN 'medium'
    WHEN 'otd-V2hhdCBpcyB0aGUgbWFpbiB0aGVtZSBzb25nIG9mICZxdW90O1' THEN 'medium'
    WHEN 'otd-V2hhdCBpcyB0aGUgbWFpbiBjaGFyYWN0ZXIgb2YgTWV0YWwgR2' THEN 'easy'
    WHEN 'otd-V2hhdCBpcyB0aGUgcGVyayB0aGF0IHdhcyBpbnRyb2R1Y2VkIG' THEN 'hard'
    WHEN 'otd-V2hhdCBpcyB0aGUgcmVhbCBuYW1lIG9mIHRoZSBTY291dCBpbi' THEN 'hard'
    WHEN 'otd-V2hhdCBpcyB0aGUgd29ybGQmIzAzOTtzIGZpcnN0IHZpZGVvIG' THEN 'easy'
    WHEN 'otd-V2hhdCBpcyB0aGUgNHRoIGJvc3MgaW4gdGhlIDE5OTcgdmlkZW' THEN 'medium'
    WHEN 'otd-V2hhdCBpcyB0aGUgQWxpZW4gUmFjZSBpbiB0aGUgZ2FtZSAmcX' THEN 'hard'
    WHEN 'otd-V2hhdCBpcyB0aGUgY29kZSBuYW1lIG9mIE1vcmdhbmEgdGhlIG' THEN 'medium'
    WHEN 'otd-V2hhdCBpcyB0aGUgYm9zcyByb3VuZCBmZWF0dXJlZCBpbiB0aG' THEN 'hard'
    WHEN 'otd-V2hhdCBpcyB0aGUgZnVsbCBuYW1lIG9mIHRoZSBwcm90YWdvbm' THEN 'hard'
    WHEN 'otd-V2hhdCBpcyBhIFRldHJpcyBwaWVjZSBjYWxsZWQ/' THEN 'easy'
    WHEN 'otd-V2hhdCBpcyBHYWJlIE5ld2VsbCYjMDM5O3MgZmF2b3JpdGUgY2' THEN 'hard'
    WHEN 'otd-V2hhdCBtaW5pbXVtIGxldmVsIGluIHRoZSBEZWZlbmNlIHNraW' THEN 'hard'
    WHEN 'otd-V2hhdCBtYWlubHkgZmF2b3JlZCByaWZsZSBpcyB1c2VkIGJ5IH' THEN 'easy'
    WHEN 'otd-V2hhdCBtYWpvciBldmVudCBjYXVzZWQgdGhlIGV2ZW50cyBvZi' THEN 'medium'
    WHEN 'otd-V2hhdCBuYW1lIGRpZCAmcXVvdDtNYXJpbyZxdW90OywgZnJvbS' THEN 'hard'
    WHEN 'otd-V2hhdCBVbHRpbWF0ZSBkb2VzIE1ha290byBOYWVnaSwgcHJvdG' THEN 'medium'
    WHEN 'otd-V2hhdCBwcm9ncmFtbWluZyBsYW5ndWFnZSB3YXMgdXNlZCB0by' THEN 'easy'
    WHEN 'otd-V2hhdCBzb25nIGlzIHBsYXllZCBkdXJpbmcgdGhlIGVuZGluZy' THEN 'hard'
    WHEN 'otd-V2hhdCBzeXN0ZW0gd2FzICZxdW90O1RvdWhvdTogSGlnaGx5IF' THEN 'hard'
    WHEN 'otd-V2hhdCYjMDM5O3MgdGhlIFRlYW0gRm9ydHJlc3MgMiBTY291dC' THEN 'medium'
    WHEN 'otd-V2hhdCYjMDM5O3MgdGhlIGZhbW91cyBsaW5lIFZhYXMgc2F5cy' THEN 'easy'
    WHEN 'otd-V2hlbiB3YXMgdGhlIFNlZ2EgR2VuZXNpcyByZWxlYXNlZCBpbi' THEN 'hard'
    WHEN 'otd-V2hlbiB3YXMgdGhlIG9yaWdpbmFsIFN0YXIgV2FyczogQmF0dG' THEN 'hard'
    WHEN 'otd-V2hlbiB3YXMgdGhlIGdhbWUgJiMwMzk7UG9ydGFsIDImIzAzOT' THEN 'medium'
    WHEN 'otd-V2hlbiB3YXMgdGhlIGZpcnN0ICZxdW90O0hhbGYtTGlmZSZxdW' THEN 'medium'
    WHEN 'otd-V2hlbiB3YXMgdGhlIHRvcC1kb3duIG9ubGluZSBSUEcgJnF1b3' THEN 'hard'
    WHEN 'otd-V2hlbiB3YXMgdGhlIHZpZGVvIGdhbWUgJnF1b3Q7UC5BLk0uRS' THEN 'hard'
    WHEN 'otd-V2hlbiB3YXMgJnF1b3Q7R2FycnkmIzAzOTtzIE1vZCZxdW90Oy' THEN 'hard'
    WHEN 'otd-V2hlbiB3YXMgJnF1b3Q7THVpZ2kmIzAzOTtzIE1hbnNpb24gMy' THEN 'hard'
    WHEN 'otd-V2hlbiB3YXMgQ2hhcHRlciAxIG9mIHRoZSBTb3VyY2UgRW5naW' THEN 'hard'
    WHEN 'otd-V2hlbiB3YXMgQ2x1YiBQZW5ndWluIGxhdW5jaGVkPw==' THEN 'hard'
    WHEN 'otd-V2hlbiB3YXMgRmluYWwgRmFudGFzeSBYViByZWxlYXNlZD8=' THEN 'hard'
    WHEN 'otd-V2hlbiB3YXMgTGVmdCA0IERlYWQgMiByZWxlYXNlZD8=' THEN 'hard'
    WHEN 'otd-V2hlbiB3YXMgTWluZWNyYWZ0IGZpcnN0IHJlbGVhc2VkIHRvIH' THEN 'medium'
    WHEN 'otd-V2hlbiB3YXMgU3RlYW0gZmlyc3QgcmVsZWFzZWQ/' THEN 'easy'
    WHEN 'otd-V2hlbiB3YXMgUG9rZW1vbiBHTyByZWxlYXNlZCBpbiBOb3J0aC' THEN 'easy'
    WHEN 'otd-V2hlcmUgZG9lcyAmcXVvdDtUaGUgTGVnZW5kIG9mIFplbGRhOi' THEN 'easy'
    WHEN 'otd-V2hpY2ggaXMgbm90IGEgcGxheWFibGUgY2hhcmFjdGVyIGluIH' THEN 'hard'
    WHEN 'otd-V2hpY2ggaXMgdGhlIHByb3RhZ29uaXN0IG9mIEJpb3Nob2NrIE' THEN 'easy'
    WHEN 'otd-V2hpY2ggb25lcyBvZiB0aGVzZSBNYXJpbyBLYXJ0IGdhbWVzIH' THEN 'easy'
    WHEN 'otd-V2hpY2ggb25lIG9mIHRoZSBmaXJzdCBmb3VyIHRpdGxlcyBvZi' THEN 'hard'
    WHEN 'otd-V2hpY2ggb25lIG9mIHRoZSBmb2xsb3dpbmcgYWN0b3JzIGRpZC' THEN 'hard'
    WHEN 'otd-V2hpY2ggb25lIG9mIHRoZXNlIG5hdGlvbnMgd2FzIGFkZGVkIH' THEN 'hard'
    WHEN 'otd-V2hpY2ggb25lIG9mIHRoZXNlIGlzIE5PVCBhbiBvZmZpY2lhbC' THEN 'medium'
    WHEN 'otd-V2hpY2ggb25lIG9mIHRoZXNlIGlzIE5PVCBhIGNoYXJhY3Rlci' THEN 'easy'
    WHEN 'otd-V2hpY2ggb25lIG9mIHRoZXNlIGNoYXJhY3RlcnMgaXMgTk9UIG' THEN 'medium'
    WHEN 'otd-V2hpY2ggb25lIG9mIHRoZXNlIGNoYXJhY3RlcnMgd2FzIGZpcn' THEN 'hard'
    WHEN 'otd-V2hpY2ggb25lIG9mIHRoZXNlIHdhcyBub3QgYSBtZW1iZXIgb2' THEN 'hard'
    WHEN 'otd-V2hpY2ggb2NjdXBhdGlvbiBkaWQgSm9obiBUYW5uZXIsIHRoZS' THEN 'medium'
    WHEN 'otd-V2hpY2ggb2YgdGhlc2UgaXMgbm90IG9uZSBvZiBEcmFjdWxhJi' THEN 'hard'
    WHEN 'otd-V2hpY2ggb2YgdGhlc2UgaXMgbm90IGEgcGxheWFibGUgY2hhcm' THEN 'hard'
    WHEN 'otd-V2hpY2ggb2YgdGhlc2UgaXMgbm90IGEgd29uZGVyIHdlYXBvbi' THEN 'hard'
    WHEN 'otd-V2hpY2ggb2YgdGhlc2UgaXMgbm90IGEgRExDIHZlaGljbGUgaW' THEN 'hard'
    WHEN 'otd-V2hpY2ggb2YgdGhlc2UgaXMgbm90IGEgRHJhZ29uIEFnZSBPcm' THEN 'hard'
    WHEN 'otd-V2hpY2ggb2YgdGhlc2UgaXMgbm90IGEgRmFsbG91dCBwcm90YW' THEN 'easy'
    WHEN 'otd-V2hpY2ggb2YgdGhlc2UgaXMgbm90IGEgY2hhcmFjdGVyIGluIH' THEN 'hard'
    WHEN 'otd-V2hpY2ggb2YgdGhlc2UgaXMgbm90IHRoZSBuYW1lIG9mIGEgY2' THEN 'easy'
    WHEN 'otd-V2hpY2ggb2YgdGhlc2UgaXMgdGhlIG5hbWUgb2YgYSBjdXQgZW' THEN 'hard'
    WHEN 'otd-V2hpY2ggb2YgdGhlc2UgaXMgTk9UIERMQyBmb3IgdGhlIHZpZG' THEN 'hard'
    WHEN 'otd-V2hpY2ggb2YgdGhlc2UgaXMgTk9UIGEgbmFtZSBvZiBhIGNpdH' THEN 'hard'
    WHEN 'otd-V2hpY2ggb2YgdGhlc2UgaXMgTk9UIGEgbmFtZSBvZiBhIHBsYX' THEN 'easy'
    WHEN 'otd-V2hpY2ggb2YgdGhlc2UgaXMgTk9UIGEgcGxheWFibGUgY2hhcm' THEN 'hard'
    WHEN 'otd-V2hpY2ggb2YgdGhlc2UgaXMgTk9UIGEgdGVycm9yaXN0IGZhY3' THEN 'hard'
    WHEN 'otd-V2hpY2ggb2YgdGhlc2UgaXMgTk9UIGEgSHVtb25nb3VzIEVudG' THEN 'hard'
    WHEN 'otd-V2hpY2ggb2YgdGhlc2UgaXMgTk9UIHRoZSBuYW1lIG9mIGEgcm' THEN 'medium'
    WHEN 'otd-V2hpY2ggb2YgdGhlc2UgaXMgTk9UIHRoZSBuYW1lIG9mIGEgdG' THEN 'easy'
    WHEN 'otd-V2hpY2ggb2YgdGhlc2UgbGV2ZWxzIGRvZXMgTk9UIGFwcGVhci' THEN 'hard'
    WHEN 'otd-V2hpY2ggb2YgdGhlc2Ugc29uZ3MgZG9lcyBOT1QgcGxheSBkdX' THEN 'hard'
    WHEN 'otd-V2hpY2ggb2YgdGhlc2Ugc3ltYm9scyBjYW4gYmUgc2VlbiBvbi' THEN 'hard'
    WHEN 'otd-V2hpY2ggb2YgdGhlc2Ugcm9sZXMgaW4gVG93biBvZiBTYWxlbS' THEN 'hard'
    WHEN 'otd-V2hpY2ggb2YgdGhlc2UgdmlkZW8gZ2FtZSBzZXJpZXMgaGF2ZS' THEN 'hard'
    WHEN 'otd-V2hpY2ggb2YgdGhlc2UgQ291bnRlci1TdHJpa2UgbWFwcyBpcy' THEN 'hard'
    WHEN 'otd-V2hpY2ggb2YgdGhlc2UgR2VuZXJhdGlvbiAxIFBva2Vtb24gZG' THEN 'medium'
    WHEN 'otd-V2hpY2ggb2YgdGhlc2UgRm9ydG5pdGUgZW1vdGVzIGRvZXMgTk' THEN 'easy'
    WHEN 'otd-V2hpY2ggb2YgdGhlc2UgU3RhcmJvdW5kIHJhY2VzIGhhcyBhIF' THEN 'hard'
    WHEN 'otd-V2hpY2ggb2YgdGhlc2UgUG9rJmVhY3V0ZTttb24gY2Fubm90IG' THEN 'medium'
    WHEN 'otd-V2hpY2ggb2YgdGhlc2UgY292ZXJ0IGdyb3VwcyBlbXBsb3lzIF' THEN 'medium'
    WHEN 'otd-V2hpY2ggb2YgdGhlc2UgY2hhcmFjdGVycyB3YXMgTk9UIHBsYW' THEN 'hard'
    WHEN 'otd-V2hpY2ggb2YgdGhlc2UgY2hhcmFjdGVycyB3YXMgYWxtb3N0IG' THEN 'hard'
    WHEN 'otd-V2hpY2ggb2YgdGhlc2UgY2hhcmFjdGVycyBpbiAmcXVvdDtVbm' THEN 'medium'
    WHEN 'otd-V2hpY2ggb2YgdGhlc2UgY2hhcmFjdGVycyBpcyBOT1QgYSBib3' THEN 'hard'
    WHEN 'otd-V2hpY2ggb2YgdGhlc2UgZ2FtZXMgd2FzIE5PVCBhIE5pbnRlbm' THEN 'hard'
    WHEN 'otd-V2hpY2ggb2YgdGhlc2UgZ2FtZXMgd2FzIHRoZSBlYXJsaWVzdC' THEN 'hard'
    WHEN 'otd-V2hpY2ggb2YgdGhlc2UgZ2FtZXMgdGFrZXMgcGxhY2UgaW4gdG' THEN 'hard'
    WHEN 'otd-V2hpY2ggb2YgdGhlc2UgZm9sbG93aW5nIHdlYXBvbiBvciBlcX' THEN 'hard'
    WHEN 'otd-V2hpY2ggb2YgdGhlc2UgZmVhdHVyZXMgd2FzIGFkZGVkIGluIH' THEN 'hard'
    WHEN 'otd-V2hpY2ggb2YgdGhlIGZvbGxvd2luZyB3YXMgTk9UIGEgcGxheW' THEN 'medium'
    WHEN 'otd-V2hpY2ggb2YgdGhlIGZvbGxvd2luZyB3YXMgYSBtYXAgdGhhdC' THEN 'hard'
    WHEN 'otd-V2hpY2ggb2YgdGhlIGZvbGxvd2luZyB3ZWFwb25zIGluICZxdW' THEN 'medium'
    WHEN 'otd-V2hpY2ggb2YgdGhlIGZvbGxvd2luZyBDb3B5IEFiaWxpdGllcy' THEN 'hard'
    WHEN 'otd-V2hpY2ggb2YgdGhlIGZvbGxvd2luZyBFbGl0ZSBGb3VyIG1lbW' THEN 'hard'
    WHEN 'otd-V2hpY2ggb2YgdGhlIGZvbGxvd2luZyBjaGFyYWN0ZXJzIHdlcm' THEN 'hard'
    WHEN 'otd-V2hpY2ggb2YgdGhlIGZvbGxvd2luZyBjb2xvcnMgZG9lcyB0aG' THEN 'hard'
    WHEN 'otd-V2hpY2ggb2YgdGhlIGZvbGxvd2luZyBnYW1lcyB3YXMgTk9UIG' THEN 'medium'
    WHEN 'otd-V2hpY2ggb2YgdGhlIGZvbGxvd2luZyBnYW1lcyBoYXMgdGhlIG' THEN 'medium'
    WHEN 'otd-V2hpY2ggb2YgdGhlIGZvbGxvd2luZyBnYW1lcyBpbiB0aGUgQW' THEN 'hard'
    WHEN 'otd-V2hpY2ggb2YgdGhlIGZvbGxvd2luZyBNYXJpbyBLYXJ0IDggRG' THEN 'easy'
    WHEN 'otd-V2hpY2ggb2YgdGhlIGZvbGxvd2luZyBoYXMgSmVubmlmZXIgVG' THEN 'hard'
    WHEN 'otd-V2hpY2ggb2YgdGhlIGZvbGxvd2luZyBpcyBOT1QgYSBzdW1tb2' THEN 'medium'
    WHEN 'otd-V2hpY2ggb2YgdGhlIGZvbGxvd2luZyBpcyBub3QgYSBjaGFyYW' THEN 'medium'
    WHEN 'otd-V2hpY2ggb2YgdGhlIGZvbGxvd2luZyBpcyBub3QgYSBmYWN0aW' THEN 'medium'
    WHEN 'otd-V2hpY2ggb2YgdGhlIGZvbGxvd2luZyBpcyBub3QgYSBwcm9zZW' THEN 'hard'
    WHEN 'otd-V2hpY2ggb2YgdGhlIGZvbGxvd2luZyBpcyBub3QgYSByZWFsIF' THEN 'easy'
    WHEN 'otd-V2hpY2ggb2YgdGhlIGZvbGxvd2luZyBuYW1lcyBpcyB0aGUgJn' THEN 'medium'
    WHEN 'otd-V2hpY2ggb2YgdGhlIGZvbGxvd2luZyBUZXJyYW4gdW5pdHMgZn' THEN 'hard'
    WHEN 'otd-V2hpY2ggb2YgMiBWYWx2ZSBHYW1lcyBhcmUgc2V0IGluIHRoZS' THEN 'medium'
    WHEN 'otd-V2hpY2ggb3BlcmF0aW9uIGluICZxdW90O1RvbSBDbGFuY3kmIz' THEN 'hard'
    WHEN 'otd-V2hpY2ggbWVtYmVyIG9mIHRoZSBWZWx2ZXQgUm9vbSBpcyBub3' THEN 'hard'
    WHEN 'otd-V2hpY2ggc291bHMgZ2FtZSB3YXMgbm90IGRpcmVjdGVkIGJ5IE' THEN 'medium'
    WHEN 'otd-V2hpY2ggc29jY2VyIHBsYXllciBpcyBmZWF0dXJlZCBvbiB0aG' THEN 'easy'
    WHEN 'otd-V2hpY2ggc3R1ZGVudCBpbiBZYW5kZXJlIFNpbXVsYXRvciBpcy' THEN 'hard'
    WHEN 'otd-V2hpY2ggc3RhZ2Ugd2FzIHBsYW5uZWQgdG8gYmUgYSBwYXJ0IG' THEN 'hard'
    WHEN 'otd-V2hpY2ggcG9wIHNpbmdlciB3YXMgYnJvdWdodCBpbiBieSBTRU' THEN 'easy'
    WHEN 'otd-V2hpY2ggcHN5Y2hvcGF0aChzKSBpbiBEZWFkIFJpc2luZyAxIG' THEN 'hard'
    WHEN 'otd-V2hpY2ggcHV6emxlIGdhbWUgd2FzIGRlc2lnbmVkIGJ5IGEgUn' THEN 'easy'
    WHEN 'otd-V2hpY2ggcmFjZSBpbiBHdWlsZCBXYXJzIDIgYmVsaWV2ZXMgaW' THEN 'medium'
    WHEN 'otd-V2hpY2ggcmV0cm8gdmlkZW8gZ2FtZSB3YXMgcmVsZWFzZWQgZm' THEN 'medium'
    WHEN 'otd-V2hpY2ggd2F0ZXItdHlwZSBQb2smZWFjdXRlO21vbiBzdGFydG' THEN 'medium'
    WHEN 'otd-V2hpY2ggd2FzIHRoZSBmaXJzdCAmcXVvdDtDYWxsIE9mIER1dH' THEN 'hard'
    WHEN 'otd-V2hpY2ggd2FzIHRoZSBmaXJzdCB2aWRlbyBnYW1lIHRvIGJlIH' THEN 'hard'
    WHEN 'otd-V2hpY2ggd2VhcG9uIHRoYXQgd2FzIGN1dCBmcm9tIHRoZSBnYW' THEN 'hard'
    WHEN 'otd-V2hpY2ggdG93biB3YXMgU2VhbXVzICZxdW90O1NsZWRnZSZxdW' THEN 'hard'
    WHEN 'otd-V2hpY2ggdmlkZW8gZ2FtZSBlYXJuZWQgbXVzaWMgY29tcG9zZX' THEN 'hard'
    WHEN 'otd-V2hpY2ggJnF1b3Q7Q2FsbCBPZiBEdXR5OiBab21iaWVzJnF1b3' THEN 'hard'
    WHEN 'otd-V2hpY2ggJnF1b3Q7RmFsbG91dDogTmV3IFZlZ2FzJnF1b3Q7IH' THEN 'hard'
    WHEN 'otd-V2hpY2ggJnF1b3Q7UGVyay1BLUNvbGEmcXVvdDsgaW4gJnF1b3' THEN 'hard'
    WHEN 'otd-V2hpY2ggQ1M6R08gZVNwb3J0cyB0ZWFtIHdvbiB0aGUgbWFqb3' THEN 'hard'
    WHEN 'otd-V2hpY2ggQ3J5cHQgb2YgdGhlIE5lY3JvRGFuY2VyICgyMDE1KS' THEN 'hard'
    WHEN 'otd-V2hpY2ggQW5pbWFsIENyb3NzaW5nIGdhbWUgd2FzIGZvciB0aG' THEN 'medium'
    WHEN 'otd-V2hpY2ggR2FtZSBCb3kgZnJvbSB0aGUgR2FtZSBCb3kgc2VyaW' THEN 'medium'
    WHEN 'otd-V2hpY2ggR2FtZSBEZXZlbG9wbWVudCBjb21wYW55IG1hZGUgTm' THEN 'easy'
    WHEN 'otd-V2hpY2ggR2VybWFuIGNpdHkgZG9lcyB0aGUgbWFwICZxdW90O0' THEN 'hard'
    WHEN 'otd-V2hpY2ggRG90YSAxIGhlcm8gY2hhbmdlZCBnZW5kZXIgd2hlbi' THEN 'hard'
    WHEN 'otd-V2hpY2ggRmluYWwgRmFudGFzeSBnYW1lIGNvbnNpc3RlZCBvZi' THEN 'medium'
    WHEN 'otd-V2hpY2ggRWxpdGUgRm91ciBtZW1iZXIgZnJvbSB0aGUgZmlyc3' THEN 'medium'
    WHEN 'otd-V2hpY2ggS2lyYnkgZ2FtZSBmaXJzdCBpbnRyb2R1Y2VkIENvcH' THEN 'medium'
    WHEN 'otd-V2hpY2ggT3ZlcndhdGNoIGNoYXJhY3RlciBzYXlzIHRoZSBsaW' THEN 'easy'
    WHEN 'otd-V2hpY2ggTWFyaW8gc3Bpbi1vZmYgZ2FtZSBkaWQgV2FsdWlnaS' THEN 'medium'
    WHEN 'otd-V2hpY2ggU29uaWMgdGhlIEhlZGdlaG9nIGdhbWUgaW50cm91ZG' THEN 'easy'
    WHEN 'otd-V2hpY2ggU29uaWMgdGhlIEhlZGdlaG9nIGdhbWUgd2FzIG9yaW' THEN 'medium'
    WHEN 'otd-V2hpY2ggU3VwZXIgTWFyaW8gdmlkZW8gZ2FtZSB3aGVuIHRoZX' THEN 'medium'
    WHEN 'otd-V2hpY2ggUG9rJmVhY3V0ZTttb24gY2FuIGxlYXJuIHRoZSBtb3' THEN 'hard'
    WHEN 'otd-V2hpY2ggUG9rZW1vbiBnZW5lcmF0aW9uIGRpZCB0aGUgZmFuLW' THEN 'hard'
    WHEN 'otd-V2hpY2ggVG91aG91IGNoYXJhY3RlciBpcyBhIEhlbGwgUmF2ZW' THEN 'hard'
    WHEN 'otd-V2hpY2ggY291bnRyeSBpcyBmZWF0dXJlZCBpbiBBY2UgQ29tYm' THEN 'hard'
    WHEN 'otd-V2hpY2ggY29tcGFueSBkZXZlbG9wZWQgdGhlIE1NTyBTcGlyYW' THEN 'hard'
    WHEN 'otd-V2hpY2ggY29tcGFueSBpcyB0aGUgb25lIHJlc3BvbnNpYmxlIG' THEN 'medium'
    WHEN 'otd-V2hpY2ggY29tcGFueSBtYWRlIHRoZSBKYXBhbmVzZSBSUEcgJn' THEN 'easy'
    WHEN 'otd-V2hpY2ggY2FyIGlzIE5PVCBmZWF0dXJlZCBpbiAmcXVvdDtOZW' THEN 'hard'
    WHEN 'otd-V2hpY2ggY2hhcmFjdGVyIGluIHRoZSAmcXVvdDtBbmltYWwgQ3' THEN 'hard'
    WHEN 'otd-V2hpY2ggY2hhcmFjdGVyIGlzIGZyb20gJnF1b3Q7U3BsYXRvb2' THEN 'easy'
    WHEN 'otd-V2hpY2ggYWN0b3IgcHJvdmlkZWQgdGhlIHZvaWNlIGZvciB0aG' THEN 'easy'
    WHEN 'otd-V2hpY2ggZ2FtaW5nIHNlcmllcyBpbmNsdWRlcyAmcXVvdDtUaG' THEN 'easy'
    WHEN 'otd-V2hpY2ggZ2FtZSB3YXMgdGhlIGZpcnN0IHRpbWUgTWFyaW8gd2' THEN 'hard'
    WHEN 'otd-V2hpY2ggZ2FtZSBkaWQgJnF1b3Q7U29uaWMgVGhlIEhlZGdlaG' THEN 'medium'
    WHEN 'otd-V2hpY2ggZ2FtZSBkaWQgTk9UIGdldCBmaW5hbmNlZCB2aWEgQ3' THEN 'medium'
    WHEN 'otd-V2hpY2ggZ2FtZSBpbiB0aGUgJnF1b3Q7RGFyayBTb3VscyZxdW' THEN 'easy'
    WHEN 'otd-V2hpY2ggZ2FtZSBpcyBOT1QgcGFydCBvZiB0aGUgU2NpZW5jZS' THEN 'hard'
    WHEN 'otd-V2hpY2ggZm9vdGJhbGwgcGxheWVyIGlzIGZlYXR1cmVkIG9uIH' THEN 'easy'
    WHEN 'otd-V2hpY2ggZnJhbmNoaXNlIHdhcyBOT1QgZmVhdHVyZWQgaW4gdG' THEN 'medium'
    WHEN 'otd-V2hpY2ggZXBpc29kZSBvZiB0aGUgUGhhbnRhc3kgU3RhciBPbm' THEN 'hard'
    WHEN 'otd-V2hvIG1hZGUgdGhlIHZpZGVvIGdhbWUsICZxdW90O0JlbmR5IG' THEN 'medium'
    WHEN 'otd-V2hvIG1hZGUgR2FycnkmIzAzOTtzIE1vZD8=' THEN 'medium'
    WHEN 'otd-V2hvIG91dCBvZiB0aGVzZSBUZWFtIEZvcnRyZXNzIDIgY2hhcm' THEN 'hard'
    WHEN 'otd-V2hvIGlzIHRoZSB2aWxsYWluIGNvbXBhbnkgaW4gJnF1b3Q7U3' THEN 'easy'
    WHEN 'otd-V2hvIGlzIHRoZSB3cml0ZXIgb2YgdGhlIGdhbWUgJnF1b3Q7SG' THEN 'hard'
    WHEN 'otd-V2hvIGlzIHRoZSBjaGFyYWN0ZXIgeW91IHBsYXkgYXMgaW4gWX' THEN 'hard'
    WHEN 'otd-V2hvIGlzIHRoZSBjcmVhdG9yIG9mIFRvdWhvdSBwcm9qZWN0Pw' THEN 'hard'
    WHEN 'otd-V2hvIGlzIHRoZSBmb3VuZGVyIG9mIFRlYW0gRm9ydHJlc3MgMi' THEN 'hard'
    WHEN 'otd-V2hvIGlzIHRoZSBoYWxmLWRlbW9uIGNoYXJhY3RlciBpbiBEaX' THEN 'hard'
    WHEN 'otd-V2hvIGlzIHRoZSBsYXN0IGJvc3MgaW4gTmlnaHQgSW4gVGhlIF' THEN 'hard'
    WHEN 'otd-V2hvIGlzIHRoZSBsZWFkZXIgb2YgdGhlIEJyb3RoZXJob29kIG' THEN 'medium'
    WHEN 'otd-V2hvIGlzIHRoZSBtYWluIGFudGFnb25pc3Qgb2YgT3JpIGFuZC' THEN 'medium'
    WHEN 'otd-V2hvIGlzIHRoZSBtYWluIGFudGFnb25pc3Qgb2YgU2lsZW50IE' THEN 'hard'
    WHEN 'otd-V2hvIGlzIHRoZSBtYWluIGNoYXJhY3RlciBpbiBNZXRhbCBHZW' THEN 'medium'
    WHEN 'otd-V2hvIGlzIHRoZSBtYWluIGNoYXJhY3RlciBpbiBtb3N0IG9mIH' THEN 'hard'
    WHEN 'otd-V2hvIGlzIHRoZSBtYWluIGNoYXJhY3RlciBvZiB0aGUgZ2FtZS' THEN 'hard'
    WHEN 'otd-V2hvIGlzIHRoZSBtYWluIHByb3RhZ29uaXN0IG9mICZxdW90O0' THEN 'hard'
    WHEN 'otd-V2hvIGlzIHRoZSBtYWluIHByb3RhZ29uaXN0IG9mIERlYWQgU3' THEN 'medium'
    WHEN 'otd-V2hvIGlzIHRoZSBtYWluIHByb3RhZ29uaXN0IGluIERhbmdhbn' THEN 'hard'
    WHEN 'otd-V2hvIGlzIHRoZSBtYWluIHZpbGxhaW4gaW4gQmVuZHkgYW5kIH' THEN 'medium'
    WHEN 'otd-V2hvIGlzIHRoZSBtYWluIHZpbGxhaW4gb2YgdGhlIENyYXNoIE' THEN 'easy'
    WHEN 'otd-V2hvIGlzIHRoZSBtYWluIHZpbGxhaW4gb2YgS2lyYnkmIzAzOT' THEN 'hard'
    WHEN 'otd-V2hvIGlzIHRoZSBwcm90YWdvbmlzdCBpbiB0aGUgZ2FtZSAmcX' THEN 'medium'
    WHEN 'otd-V2hvIGlzIHRoZSBwcm90YWdvbmlzdCBpbiBEZWFkIFJpc2luZy' THEN 'medium'
    WHEN 'otd-V2hvIGNvbXBvc2VkIHRoZSBzb3VuZHRyYWNrIGZvciB0aGUgZ2' THEN 'hard'
    WHEN 'otd-V2hvIGNyZWF0ZWQgdGhlIGluZGllIGFkdmVudHVyZSBnYW1lIC' THEN 'hard'
    WHEN 'otd-V2hvIGNyZWF0ZWQgQWdlbnQgNDcgaW4gdGhlIGdhbWUgc2VyaW' THEN 'hard'
    WHEN 'otd-V2hvIGRldmVsb3BlZCB0aGUgMjAxNiBmYXJtaW5nIFJQRyAmcX' THEN 'easy'
    WHEN 'otd-V2hvIHdhcyB0aGUgbWFpbiBhbnRhZ29uaXN0IG9mIE1heCBQYX' THEN 'hard'
    WHEN 'otd-V2hvIHdhcyB0aGUgdm9pY2UgYWN0b3IgZm9yIFNuYWtlIGluIE' THEN 'medium'
    WHEN 'otd-V2hvIHdhcyB0aGUgZmlyc3QgamVkaSB0aGF0IFN0YXJraWxsZX' THEN 'hard'
    WHEN 'otd-V2hvIHdhcyBUZXRyaXMgY3JlYXRlZCBieT8=' THEN 'easy'
    WHEN 'otd-V2hvIHR1cm5zIG91dCB0byBiZSB0aGUgdHJ1ZSB2aWN0b3IgaW' THEN 'hard'
    WHEN 'otd-V2hvIHZvaWNlcyB0aGUgaW5mYW1vdXMgQ2l0YWRlbCBTdGF0aW' THEN 'hard'
    WHEN 'otd-V2hvIHZvaWNlcyB0aGUgY2hhcmFjdGVyICZxdW90O1Zlcm5vbi' THEN 'hard'
    WHEN 'otd-V2hvIHZvaWNlcyBHTGFET1MgaW4gdGhlIFBvcnRhbCBnYW1lcz' THEN 'medium'
    WHEN 'otd-V2hvIHZvaWNlcyBNYXggUGF5bmUgaW4gdGhlIDIwMDEgZ2FtZS' THEN 'hard'
    WHEN 'otd-V2hvJiMwMzk7cyB0aGUgdm9pY2UgYWN0b3IgZm9yIFRocmFsbC' THEN 'medium'
    WHEN 'otd-V2hvJiMwMzk7cyB0aGUgQ2FwdGFpbiBvZiB0aGUgUy5ULkEuUi' THEN 'hard'
    WHEN 'otd-V2l0aG91dCBlbmNoYW50bWVudHMsIHdoaWNoIHBpY2theGUgaW' THEN 'easy'
    WHEN 'otd-VEYyOiBUaGUgSGVhdnkmIzAzOTtzIHZvaWNlIGFjdG9yLCBHYX' THEN 'hard'
    WHEN 'otd-VEYyOiBXaGF0IGNvZGUgZG9lcyBTb2xkaWVyIHB1dCBpbnRvIH' THEN 'hard'
    WHEN 'otd-VG9ieSBGb3gmIzAzOTtzICZxdW90O01lZ2Fsb3ZhbmlhJnF1b3' THEN 'hard'
    WHEN 'otd-VGhlICYjMDM5OzY0JiMwMzk7IGluIHRoZSBOaW50ZW5kby02NC' THEN 'easy'
    WHEN 'otd-VGhlICZsZHF1bztmYWlyeSZyZHF1bzsgdHlwZSBtYWRlIGl0Jn' THEN 'medium'
    WHEN 'otd-VGhlIDIwMDUgdmlkZW8gZ2FtZSAmcXVvdDtDYWxsIG9mIER1dH' THEN 'hard'
    WHEN 'otd-VGhlIE1hbm4gQ28uIFN0b3JlIGZyb20gVGVhbSBGb3J0cmVzcy' THEN 'hard'
    WHEN 'otd-VGhlIEFEQU0gY29sbGVjdGVycyBpbiB0aGUgQmlvc2hvY2sgc2' THEN 'easy'
    WHEN 'otd-VGhlIEFjZSBBdHRvcm5leSB0cmlsb2d5IHdhcyBzdXBwb3NlIH' THEN 'hard'
    WHEN 'otd-VGhlIEJyYWNrZW4gZnJvbSBMZXRoYWwgQ29tcGFueSBpcyBhbH' THEN 'medium'
    WHEN 'otd-VGhlIEludGVybmV0IE1lbWUgJnF1b3Q7QWxsIHlvdXIgYmFzZS' THEN 'medium'
    WHEN 'otd-VGhlIEluZGllIEdhbWUgRGV2ZWxvcG1lbnQgU3R1ZGlvIENpbm' THEN 'hard'
    WHEN 'otd-VGhlIEtlcmJvbCBTeXN0ZW0gKGZyb20gS2VyYmFsIFNwYWNlIF' THEN 'hard'
    WHEN 'otd-VGhlIEtvbmFtaSBDb2RlIGlzIGtub3duIGFzIFVwLCBVcCwgRG' THEN 'medium'
    WHEN 'otd-VGhlIEZpYXQgTXVsdGlwbGEgaXMgYSBkcml2YWJsZSBjYXIgaW' THEN 'easy'
    WHEN 'otd-VGhlIFBsYXlTdGF0aW9uIHdhcyBvcmlnaW5hbGx5IGEgam9pbn' THEN 'medium'
    WHEN 'otd-VGhlIFNuaXBlciYjMDM5O3MgU01HIGluIFRlYW0gRm9ydHJlc3' THEN 'hard'
    WHEN 'otd-VGhlIFRvdWhvdSBQcm9qZWN0IHNlcmllcyBvZiBnYW1lcyBpcy' THEN 'medium'
    WHEN 'otd-VGhlIG1haW4gcGxheWFibGUgY2hhcmFjdGVyIG9mIHRoZSAyMD' THEN 'medium'
    WHEN 'otd-VGhlIG1haW4gYW50YWdvbmlzdCBpbiB0aGUgdmlkZW9nYW1lIF' THEN 'hard'
    WHEN 'otd-VGhlIG1vc3QgZ3JhcGhpY2FsbHkgdmlvbGVudCBnYW1lIHRvIH' THEN 'medium'
    WHEN 'otd-VGhlIG5hbWVzIG9mIFRvbSBOb29rJiMwMzk7cyBjb3VzaW5zIG' THEN 'medium'
    WHEN 'otd-VGhlIG9yaWdpbmFsIFBsYW5ldHNpZGUgd2FzIHJlbGVhc2VkIG' THEN 'hard'
    WHEN 'otd-VGhlIG9yaWdpbmFsIG1hc2NvdCBvZiB0aGUgcG9wdWxhciBOaW' THEN 'hard'
    WHEN 'otd-VGhlIGdhbWUgJnF1b3Q7SmV0cGFjayBKb3lyaWRlJnF1b3Q7IH' THEN 'hard'
    WHEN 'otd-VGhlIGdhbWUgJnF1b3Q7UG9ja2V0IE1vcnR5JnF1b3Q7IGhhcy' THEN 'medium'
    WHEN 'otd-VGhlIGdhbWUgR2FycnkmIzAzOTtzIE1vZCBvcmlnaW5hbGx5IH' THEN 'hard'
    WHEN 'otd-VGhlIGdhbWVzIENyeSBvZiBGZWFyLCBOYXR1cmFsIFNlbGVjdG' THEN 'medium'
    WHEN 'otd-VGhlIGdob3N0cyBpbiAmcXVvdDtQYWMtTWFuJnF1b3Q7IGFuZC' THEN 'medium'
    WHEN 'otd-VGhlIGNoYXJhY3RlciB0aGF0IHdvdWxkIGV2ZW50dWFsbHkgYm' THEN 'hard'
    WHEN 'otd-VGhlIGNyZWVwZXIgaW4gTWluZWNyYWZ0IHdhcyB0aGUgcmVzdW' THEN 'easy'
    WHEN 'otd-VGhlIGRlZmF1bHQgcGxheWVybW9kZWwgb2YgR2FycnkmIzAzOT' THEN 'hard'
    WHEN 'otd-VGhlIGVkdXRhaW5tZW50IHZpZGVvIGdhbWUgc2VyaWVzIGNoYX' THEN 'hard'
    WHEN 'otd-VGhlIGVuZCBjcmVkaXRzIHNlcXVlbmNlIGluIEdyYW5kIFRoZW' THEN 'medium'
    WHEN 'otd-VGhlIGZpcnN0ICZxdW90O01ldGFsIEdlYXImcXVvdDsgZ2FtZS' THEN 'medium'
    WHEN 'otd-VGhlIGZpcnN0IE1heGlzIGdhbWUgdG8gZmVhdHVyZSB0aGUgZm' THEN 'hard'
    WHEN 'otd-VGhlIGZpcnN0IGdhbWUgaW4gdGhlIFRvdWhvdSBQcm9qZWN0LC' THEN 'hard'
    WHEN 'otd-VGhlIGZpcnN0IHZlcnNpb24gb2YgQmxvY2tsYW5kIGNhbWUgb3' THEN 'hard'
    WHEN 'otd-VGhlIHByb3RhZ29uaXN0IG9mIERlYWQgUmlzaW5nIDMgaXMgY2' THEN 'medium'
    WHEN 'otd-VGhlIHByb3RhZ29uaXN0IGluIHRoZSBnYW1lICZxdW90O0Nhdm' THEN 'hard'
    WHEN 'otd-VGhlIHdhbGxzIG9mIHRoZSBHb2xkZW5yb2QgQ2l0eSBHeW0gaW' THEN 'hard'
    WHEN 'otd-VGhlIHJldGFpbCBkaXNjIG9mIFRvbnkgSGF3ayYjMDM5O3MgUH' THEN 'medium'
    WHEN 'otd-VGhlIHJpZ2h0cyB0byB0aGUgJnF1b3Q7UmF5bWFuJnF1b3Q7IH' THEN 'easy'
    WHEN 'otd-VGhlIHN0YXJ0aW5nIHBpc3RvbCBvZiB0aGUgVGVycm9yaXN0IH' THEN 'medium'
    WHEN 'otd-VGhlIHNjcmFwcGVkIFNvbmljIHRoZSBIZWRnZWhvZyAyIGxldm' THEN 'hard'
    WHEN 'otd-VGhlIHNob3RndW4gYXBwZWFycyBpbiBldmVyeSBudW1iZXJlZC' THEN 'medium'
    WHEN 'otd-VGhlIHNvbmcgJnF1b3Q7TWVnYWxvdmFuaWEmcXVvdDsgYnkgVG' THEN 'medium'
    WHEN 'otd-VGhlIHZpZGVvIGdhbWUgcHVibGlzaGVycyBrbm93biBhcyAmcX' THEN 'hard'
    WHEN 'otd-VmFsdmUgQ29ycG9yYXRpb24gaXMgYW4gQW1lcmljYW4gdmlkZW' THEN 'hard'
    WHEN 'otd-VmFsdmUmIzAzOTtzICZxdW90O1BvcnRhbCZxdW90OyBhbmQgJn' THEN 'medium'
    WHEN 'otd-JnF1b3Q7TW9uZ29saWEmcXVvdDsgd2FzIGEgcGFydCBvZiB0aG' THEN 'easy'
    WHEN 'otd-Q2FsaWZvcm5pYSBpcyBsYXJnZXIgdGhhbiBKYXBhbi4=' THEN 'medium'
    WHEN 'otd-QmlraW5pIEF0b2xsIGlzIGluIHdoaWNoIGNvdW50cnk/' THEN 'hard'
    WHEN 'otd-QnJvb21lIGlzIGEgdG93biBpbiB3aGljaCBzdGF0ZSBvZiBBdX' THEN 'hard'
    WHEN 'otd-QWxsIG9mIHRoZSBmb2xsb3dpbmcgYXJlIGNsYXNzaWZpZWQgYX' THEN 'hard'
    WHEN 'otd-QWxsIG9mIHRoZSBmb2xsb3dpbmcgYXJlIHRvd25zL3ZpbGxhZ2' THEN 'hard'
    WHEN 'otd-QXJnZW50aW5hJiMwMzk7cyBuYW1lIGNvbWVzIGZyb20gdGhlIG' THEN 'medium'
    WHEN 'otd-R290aGVuYnVyZyBpcyB0aGUgY2FwaXRhbCBvZiBTd2VkZW4u' THEN 'easy'
    WHEN 'otd-R2licmFsdGFyLCBsb2NhdGVkIGp1c3Qgc291dGggb2YgdGhlIE' THEN 'easy'
    WHEN 'otd-R3JlZW5sYW5kIGlzIGEgcGFydCBvZiB3aGljaCBraW5nZG9tPw' THEN 'medium'
    WHEN 'otd-R3JlZW5sYW5kIGlzIGFsbW9zdCBhcyBiaWcgYXMgQWZyaWNhLg' THEN 'medium'
    WHEN 'otd-S3VhbGEgTHVtcHVyIGlzIHRoZSBjYXBpdGFsIG9mIHdoaWNoIG' THEN 'easy'
    WHEN 'otd-SG93IG1hbnkgaW5kZXBlbmRlbnQgY291bnRyaWVzIGFyZSB0aG' THEN 'hard'
    WHEN 'otd-SG93IG1hbnkgc3RhcnMgYXJlIGZlYXR1cmVkIG9uIE5ldyBaZW' THEN 'hard'
    WHEN 'otd-SG93IG1hbnkgcHJvdmluY2VzIGFyZSBpbiB0aGUgTmV0aGVybG' THEN 'hard'
    WHEN 'otd-SG93IG1hbnkgdGltZSB6b25lcyBkb2VzIENoaW5hIGhhdmU/' THEN 'medium'
    WHEN 'otd-SG93IG1hbnkgY291bnRpZXMgaW4gdGhlIFJlcHVibGljIG9mIE' THEN 'hard'
    WHEN 'otd-SG93IG1hbnkgY291bnRyaWVzIGFyZSBpbnNpZGUgdGhlIFVuaX' THEN 'easy'
    WHEN 'otd-SG93IG1hbnkgY291bnRyaWVzIGFyZSBsYXJnZXIgdGhhbiBBdX' THEN 'hard'
    WHEN 'otd-SG93IG1hbnkgY291bnRyaWVzIGRvZXMgTWV4aWNvIGJvcmRlcj' THEN 'medium'
    WHEN 'otd-SG93IG1hbnkgZmVkZXJhbCBzdGF0ZXMgZG9lcyBHZXJtYW55IG' THEN 'medium'
    WHEN 'otd-SG93IHRhbGwgaXMgT25lIFdvcmxkIFRyYWRlIENlbnRlciBpbi' THEN 'hard'
    WHEN 'otd-SGFydmFyZCBVbml2ZXJzaXR5IGlzIGxvY2F0ZWQgaW4gd2hpY2' THEN 'medium'
    WHEN 'otd-SHVuZ2FyeSBpcyB0aGUgb25seSBjb3VudHJ5IGluIHRoZSB3b3' THEN 'medium'
    WHEN 'otd-SmFwYW4gaGFzIGxlZnQtaGFuZCBzaWRlIHRyYWZmaWMu' THEN 'easy'
    WHEN 'otd-SW4gd2hpY2ggRW5nbGlzaCBjb3VudHkgaXMgdGhlIGNpdHkgb2' THEN 'hard'
    WHEN 'otd-SW4gd2hpY2ggY291bnRyeSBpcyBsb2NhdGVkIHRoZSBtdW5pY2' THEN 'hard'
    WHEN 'otd-SW50byB3aGljaCBiYXNpbiBkb2VzIHRoZSBKb3JkYW4gUml2ZX' THEN 'medium'
    WHEN 'otd-SXNyYWVsIGlzIDcgaG91cnMgYWhlYWQgb2YgTmV3IFlvcmsu' THEN 'hard'
    WHEN 'otd-T24gd2hpY2ggY29udGluZW50IGlzIHRoZSBjb3VudHJ5IG9mIE' THEN 'easy'
    WHEN 'otd-T3VhZ2Fkb3Vnb3UgaXMgdGhlIGNhcGl0YWwgb2Ygd2hpY2ggQW' THEN 'medium'
    WHEN 'otd-Tm92YSBTY290aWEgaXMgb24gdGhlIGVhc3QgY29hc3Qgb2YgQ2' THEN 'medium'
    WHEN 'otd-TW9udHJlYWwgaXMgaW4gd2hpY2ggQ2FuYWRpYW4gcHJvdmluY2' THEN 'easy'
    WHEN 'otd-U291dGggQWZyaWNhIGhhcyBtb3JlIHRoYW4gb25lIGNhcGl0YW' THEN 'medium'
    WHEN 'otd-U2FudG9yaW5pIGlzIGFuIGlzbGFuZCBiZWxvbmdpbmcgdG8gd2' THEN 'easy'
    WHEN 'otd-U2FuIE1hcmlubyBpcyB0aGUgb25seSBjb3VudHJ5IGNvbXBsZX' THEN 'medium'
    WHEN 'otd-U2VvdWwgaXMgdGhlIGNhcGl0YWwgb2YgTm9ydGggS29yZWEu' THEN 'easy'
    WHEN 'otd-UG9ydHVnYWwmIzAzOTtzIG1vZGVybiB0ZXJyaXRvcnkgd2FzIG' THEN 'medium'
    WHEN 'otd-Um91dGUgNjYgaW4gdGhlIFVuaXRlZCBTdGF0ZXMgc3BhbnMgdG' THEN 'easy'
    WHEN 'otd-UnVzc2lhIHNoYXJlcyBhIGxhbmQgYm9yZGVyIHdpdGggTm9ydG' THEN 'hard'
    WHEN 'otd-V2hhdCB0aW55IHByaW5jaXBhbGl0eSBsaWVzIGJldHdlZW4gU3' THEN 'easy'
    WHEN 'otd-V2hhdCB3YXMgdGhlIG9yaWdpbmFsIG5hbWUgb2YgSG8gQ2hpIE' THEN 'medium'
    WHEN 'otd-V2hhdCBFdXJvcGVhbiBjb3VudHJ5IGlzIG5vdCBhIHBhcnQgb2' THEN 'easy'
    WHEN 'otd-V2hhdCBjb250aW5lbnQgaXMgdGhlIGNvdW50cnkgTGVzb3Roby' THEN 'easy'
    WHEN 'otd-V2hhdCBjb3VudHJ5IGhhcyBhIGhvcml6b250YWwgYmljb2xvci' THEN 'medium'
    WHEN 'otd-V2hhdCBjb3VudHJ5IGlzIG5vdCBhIHBhcnQgb2YgU2NhbmRpbm' THEN 'medium'
    WHEN 'otd-V2hhdCBldmVudCBsZWQgdG8gTGllY2hlbnN0ZWluIGFkZGluZy' THEN 'hard'
    WHEN 'otd-V2hhdCBOb3J0aCBBbWVyaWNhbiB0b3VyaXN0IGF0dHJhY3Rpb2' THEN 'medium'
    WHEN 'otd-V2hhdCBpc2xhbmQgaW4gdGhlIENhbmFyeSBJc2xhbmRzIHdhcy' THEN 'hard'
    WHEN 'otd-V2hhdCBpcyB0aGUgaGlnaGVzdCBtb3VudGFpbiBpbiB0aGUgd2' THEN 'easy'
    WHEN 'otd-V2hhdCBpcyB0aGUgb2ZmaWNpYWwgbGFuZ3VhZ2Ugb2YgQmh1dG' THEN 'hard'
    WHEN 'otd-V2hhdCBpcyB0aGUgbG9uZ2VzdCByaXZlciBpbiBFdXJvcGU/' THEN 'easy'
    WHEN 'otd-V2hhdCBpcyB0aGUgbGFyZ2VzdCBjb3VudHJ5LCBieSBhcmVhLC' THEN 'medium'
    WHEN 'otd-V2hhdCBpcyB0aGUgbGFyZ2VzdCBmcmVzaHdhdGVyIGxha2UgYn' THEN 'medium'
    WHEN 'otd-V2hhdCBpcyB0aGUgbGFyZ2VzdCBub24tY29udGluZW50YWwgaX' THEN 'easy'
    WHEN 'otd-V2hhdCBpcyB0aGUgbm9ydGhlcm5tb3N0IGh1bWFuIHNldHRsZW' THEN 'hard'
    WHEN 'otd-V2hhdCBpcyB0aGUgbmFtZSBvZiB0aGUgQ2FuYWRpYW4gbmF0aW' THEN 'medium'
    WHEN 'otd-V2hhdCBpcyB0aGUgbmFtZSBvZiB0aGUgY2FwaXRhbCBvZiBUdX' THEN 'easy'
    WHEN 'otd-V2hhdCBpcyB0aGUgcmlnaHQgd2F5IHRvIHNwZWxsIHRoZSBjYX' THEN 'easy'
    WHEN 'otd-V2hhdCBpcyB0aGUgRmlubmlzaCB3b3JkIGZvciAmcXVvdDtGaW' THEN 'medium'
    WHEN 'otd-V2hhdCBpcyB0aGUgUG9saXNoIGNpdHkga25vd24gdG8gR2VybW' THEN 'medium'
    WHEN 'otd-V2hhdCBpcyB0aGUgY2FwaXRhbCBvZiBBdXN0cmFsaWE/' THEN 'easy'
    WHEN 'otd-V2hhdCBpcyB0aGUgY2FwaXRhbCBvZiBCcmF6aWw/' THEN 'easy'
    WHEN 'otd-V2hhdCBpcyB0aGUgY2FwaXRhbCBvZiBCcml0aXNoIENvbHVtYm' THEN 'hard'
    WHEN 'otd-V2hhdCBpcyB0aGUgY2FwaXRhbCBvZiBCdXJraW5hIEZhc28/' THEN 'medium'
    WHEN 'otd-V2hhdCBpcyB0aGUgY2FwaXRhbCBvZiBCYW5nbGFkZXNoPw==' THEN 'medium'
    WHEN 'otd-V2hhdCBpcyB0aGUgY2FwaXRhbCBvZiBDaGlsZT8=' THEN 'easy'
    WHEN 'otd-V2hhdCBpcyB0aGUgY2FwaXRhbCBvZiBHcmVlbmxhbmQ/' THEN 'hard'
    WHEN 'otd-V2hhdCBpcyB0aGUgY2FwaXRhbCBvZiBJbmRvbmVzaWE/' THEN 'medium'
    WHEN 'otd-V2hhdCBpcyB0aGUgY2FwaXRhbCBvZiBKYW1haWNhPw==' THEN 'medium'
    WHEN 'otd-V2hhdCBpcyB0aGUgY2FwaXRhbCBvZiBMYW9zPw==' THEN 'hard'
    WHEN 'otd-V2hhdCBpcyB0aGUgY2FwaXRhbCBvZiBNYXVyaXRpdXM/' THEN 'medium'
    WHEN 'otd-V2hhdCBpcyB0aGUgY2FwaXRhbCBvZiBQZXJ1Pw==' THEN 'easy'
    WHEN 'otd-V2hhdCBpcyB0aGUgY2FwaXRhbCBvZiBSb21hbmlhPw==' THEN 'medium'
    WHEN 'otd-V2hhdCBpcyB0aGUgY2FwaXRhbCBvZiBTZW5lZ2FsPw==' THEN 'easy'
    WHEN 'otd-V2hhdCBpcyBDYW5hZGEmIzAzOTtzIHNtYWxsZXN0IHByb3Zpbm' THEN 'hard'
    WHEN 'otd-V2hhdCBpcyBSdXNzaWEmIzAzOTtzIHNlY29uZC1sYXJnZXN0IG' THEN 'medium'
    WHEN 'otd-V2hhdCBpcyBzcGVjaWFsIGFib3V0IExha2UgVGl0aWNhY2E/' THEN 'medium'
    WHEN 'otd-V2hhdCBtb3VudGFpbiByYW5nZSBsaW5lcyB0aGUgYm9yZGVyIG' THEN 'easy'
    WHEN 'otd-V2hlcmUgaXMgdGhlIFZvbGdhIFJpdmVyPw==' THEN 'easy'
    WHEN 'otd-V2hlcmUgaXMgdGhlIGFuY2llbnQgY2l0eSBvZiBQZXRyYSBsb2' THEN 'easy'
    WHEN 'otd-V2hlcmUgaXMgdGhlIGNpdHkgb2YgSGFhcmxlbSBsb2NhdGVkPw' THEN 'medium'
    WHEN 'otd-V2hlcmUgaXMgdGhlIHdvcmxkJiMwMzk7cyBvbGRlc3Qgc3RpbG' THEN 'hard'
    WHEN 'otd-V2hlcmUgaXMgVGltYnVrdHUgbG9jYXRlZD8=' THEN 'easy'
    WHEN 'otd-V2hlcmUgd291bGQgeW91IGZpbmQgdGhlICZxdW90O1NwYW5pc2' THEN 'medium'
    WHEN 'otd-V2hpY2ggaXMgbm90IGEgY291bnRyeSBpbiBBZnJpY2E/' THEN 'easy'
    WHEN 'otd-V2hpY2ggaXMgdGhlIGxhcmdlc3Qgb2YgdGhlc2UgNCBpc2xhbm' THEN 'hard'
    WHEN 'otd-V2hpY2ggaXMgdGhlIHdvcmxkJiMwMzk7cyBsb25nZXN0IHJpdm' THEN 'easy'
    WHEN 'otd-V2hpY2ggaXMgdGhlIHNtYWxsZXN0IGNvdW50cnkgaW4gdGhlIH' THEN 'easy'
    WHEN 'otd-V2hpY2ggaXNsYW5kcyBiZWxvdyBoYXZlIGJlZW4gY2xhaW1lZC' THEN 'hard'
    WHEN 'otd-V2hpY2ggb25lIG9mIHRoZXNlIGFyY2hpcGVsYWdvcyBhcmUgTk' THEN 'hard'
    WHEN 'otd-V2hpY2ggb2YgdGhlc2UgaXMgTk9UIGEgcHJvdmluY2UgaW4gQ2' THEN 'medium'
    WHEN 'otd-V2hpY2ggb2YgdGhlc2UgaXMgTk9UIGEgcmVhbCB0ZWN0b25pYy' THEN 'medium'
    WHEN 'otd-V2hpY2ggb2YgdGhlc2UgaXMgTk9UIGEgY2l0eSBpbiBJbmRpYT' THEN 'medium'
    WHEN 'otd-V2hpY2ggb2YgdGhlc2UgaXMgTk9UIGEgY2l0eSBpbiBTYXVkaS' THEN 'easy'
    WHEN 'otd-V2hpY2ggb2YgdGhlc2UgaXMgTk9UIGFuIEF1c3RyYWxpYW4gc3' THEN 'medium'
    WHEN 'otd-V2hpY2ggb2YgdGhlc2UgaXNsYW5kIGNvdW50cmllcyBpcyBsb2' THEN 'medium'
    WHEN 'otd-V2hpY2ggb2YgdGhlc2UgQW1lcmljYW4gY2l0aWVzIGhhcyBmZX' THEN 'hard'
    WHEN 'otd-V2hpY2ggb2YgdGhlc2UgQWZyaWNhbiBjb3VudHJpZXMgbGlzdC' THEN 'medium'
    WHEN 'otd-V2hpY2ggb2YgdGhlc2UgQWZyaWNhbiByZWdpb25zIGRvZXMgKm' THEN 'hard'
    WHEN 'otd-V2hpY2ggb2YgdGhlc2UgTWVkaXRlcnJhbmlhbiBpc2xhbmRzIG' THEN 'easy'
    WHEN 'otd-V2hpY2ggb2YgdGhlc2UgY291bnRyaWVzIGlzICZxdW90O2RvdW' THEN 'hard'
    WHEN 'otd-V2hpY2ggb2YgdGhlc2UgY291bnRyaWVzIGlzIE5PVCBhIHBhcn' THEN 'easy'
    WHEN 'otd-V2hpY2ggb2YgdGhlc2UgY291bnRyaWVzIGlzIG5vdCB3cml0dG' THEN 'hard'
    WHEN 'otd-V2hpY2ggb2YgdGhlc2UgY291bnRyaWVzIGlzIG5vdCBhIFVuaX' THEN 'hard'
    WHEN 'otd-V2hpY2ggb2YgdGhlc2UgY291bnRyaWVzIGlzIHRoZSBzbWFsbG' THEN 'hard'
    WHEN 'otd-V2hpY2ggb2YgdGhlc2UgY2l0aWVzIGlzIE5PVCBpbiBFbmdsYW' THEN 'easy'
    WHEN 'otd-V2hpY2ggb2YgdGhlIGZvbGxvd2luZyBBcmFiIGNvdW50cmllcy' THEN 'hard'
    WHEN 'otd-V2hpY2ggb2YgdGhlIGZvbGxvd2luZyBFdXJvcGVhbiBsYW5ndW' THEN 'hard'
    WHEN 'otd-V2hpY2ggb2YgdGhlIGZvbGxvd2luZyBjaXRpZXMgaXMgdGhlIG' THEN 'easy'
    WHEN 'otd-V2hpY2ggb2YgdGhlIGZvbGxvd2luZyBjb3VudHJpZXMgaGFzIG' THEN 'hard'
    WHEN 'otd-V2hpY2ggb2YgdGhlIGZvbGxvd2luZyBjb3VudHJpZXMgaXMgd2' THEN 'hard'
    WHEN 'otd-V2hpY2ggb2YgdGhlIGZvbGxvd2luZyBjb3VudHJpZXMgYmFubm' THEN 'hard'
    WHEN 'otd-V2hpY2ggb2YgdGhlIGZvbGxvd2luZyBKYXBhbmVzZSBpc2xhbm' THEN 'medium'
    WHEN 'otd-V2hpY2ggb2YgdGhlIGZvbGxvd2luZyBmb3JtZXIgWXVnb3NsYX' THEN 'medium'
    WHEN 'otd-V2hpY2ggb2YgdGhlIGZvbGxvd2luZyBpcyBOT1QgYSBjYXBpdG' THEN 'easy'
    WHEN 'otd-V2hpY2ggb2YgdGhlIGZvbGxvd2luZyBpcyBub3QgYSBtZWdhZG' THEN 'hard'
    WHEN 'otd-V2hpY2ggb2YgdGhlIGZvbGxvd2luZyBsYW5kbG9ja2VkIGNvdW' THEN 'medium'
    WHEN 'otd-V2hpY2ggb2YgdGhlIGZvbGxvd2luZyBsYW5ndWFnZSBmYW1pbG' THEN 'hard'
    WHEN 'otd-V2hpY2ggb2YgdGhlIGZvbGxvd2luZyBsYW5ndWFnZXMgZG9lcy' THEN 'medium'
    WHEN 'otd-V2hpY2ggbmF0aW9uIGNsYWltcyBvd25lcnNoaXAgb2YgQW50YX' THEN 'medium'
    WHEN 'otd-V2hpY2ggc3RyZXRjaCBvZiB3YXRlciBjb25uZWN0cyB0aGUgQX' THEN 'easy'
    WHEN 'otd-V2hpY2ggdHdvIG1vZGVybi1kYXkgY291bnRyaWVzIHVzZWQgdG' THEN 'hard'
    WHEN 'otd-V2hpY2ggQ2FuYWRpYW4gcHJvdmluY2UgaGFzIENoYXJsb3R0ZX' THEN 'hard'
    WHEN 'otd-V2hpY2ggQm9yb3VnaCBpcyB0aGUgZmFydGhlc3QgaW4gdGhlIG' THEN 'medium'
    WHEN 'otd-V2hpY2ggRW5nbGlzaCBjb3VudHkgd2lsbCB5b3UgZmluZCB0aG' THEN 'hard'
    WHEN 'otd-V2hpY2ggRXVyb3BlYW4gY2l0eSBoYXMgdGhlIGhpZ2hlc3QgbW' THEN 'hard'
    WHEN 'otd-V2hpY2ggUnVzc2lhbiBvYmxhc3QgZm9ybXMgYSBib3JkZXIgd2' THEN 'medium'
    WHEN 'otd-V2hpY2ggVVMgc3RhdGUgaXMgYWxzbyBrbm93biBhcyB0aGUgJn' THEN 'medium'
    WHEN 'otd-V2hpY2ggY291bnRyeSB3YXMgTk9UIHBhcnQgb2YgdGhlIFNvdm' THEN 'medium'
    WHEN 'otd-V2hpY2ggY291bnRyeSBkb2VzIEF1c3RyaWEgbm90IGJvcmRlcj' THEN 'medium'
    WHEN 'otd-V2hpY2ggY291bnRyeSBpcyB0aGUgaG9tZSBvZiB0aGUgbGFyZ2' THEN 'hard'
    WHEN 'otd-V2hpY2ggY291bnRyeSBpcyBjb21wbGV0ZWx5IGxhbmRsb2NrZW' THEN 'medium'
    WHEN 'otd-V2hpY2ggY2l0eSBpcyB0aGUgYmlnZ2VzdCBpbiBDYW5hZGE/' THEN 'medium'
    WHEN 'otd-V2l0aCB3aGljaCBjb3VudHJ5IGRvZXMgRnJhbmNlIHNoYXJlIG' THEN 'medium'
    WHEN 'otd-VG9yb250byBpcyB0aGUgY2FwaXRhbCBjaXR5IG9mIHRoZSBOb3' THEN 'medium'
    WHEN 'otd-VGFzbWFuaWEgaXMgYW4gaXNsYW5kIHN0YXRlIG9mIEF1c3RyYW' THEN 'easy'
    WHEN 'otd-VGhlcmUgaXMgYSBjaXR5IGNhbGxlZCBSb21lIGluIGV2ZXJ5IG' THEN 'medium'
    WHEN 'otd-VGhlcmUgaXMgYW4gaXNsYW5kIGluIEphcGFuIGNhbGxlZCDFjG' THEN 'medium'
    WHEN 'otd-VGhlcmUgZXhpc3RzIGFuIGlzbGFuZCBuYW1lZCAmcXVvdDtKYX' THEN 'easy'
    WHEN 'otd-VGhlIEdhbWJpYSBpcyBhIG5hdGlvbiBmb3VuZCBvbiB3aGljaC' THEN 'easy'
    WHEN 'otd-VGhlIFB5cmVuZWVzIG1vdW50YWlucyBhcmUgbG9jYXRlZCBvbi' THEN 'easy'
    WHEN 'otd-VGhlIFdoaXRlIENsaWZmcyBvZiBEb3ZlciBpcyBsb2NhdGVkIG' THEN 'easy'
    WHEN 'otd-VGhlIFJlcHVibGljIG9mIE1hbHRhIGlzIHRoZSBzbWFsbGVzdC' THEN 'medium'
    WHEN 'otd-VGhlIFNvbm9yYW4gRGVzZXJ0IGlzIGxvY2F0ZWQgaW4gZWFzdG' THEN 'easy'
    WHEN 'otd-VGhlIFNwYWNlIE5lZWRsZSBpcyBsb2NhdGVkIGluIHdoaWNoIG' THEN 'medium'
    WHEN 'otd-VGhlIFVTIHN0YXRlIG9mIE5ldyBZb3JrIGhhcyBhYm91dCBhcy' THEN 'hard'
    WHEN 'otd-VGhlIGNhcGl0YWwgb2YgQnJhemlsIGlzIFJpbyBkZSBKYW5laX' THEN 'easy'
    WHEN 'otd-VGhlIGNvdW50cnkgb2YgQmVsaXplIGJvcmRlcnMgd2hpY2ggY2' THEN 'hard'
    WHEN 'otd-VGhlIGRlcmlzaXZlIGFjcm9ueW0gJnF1b3Q7UElJR1MmcXVvdD' THEN 'medium'
    WHEN 'otd-VGhlIGxhbmQgbWFzcyBvZiBtb2Rlcm4gZGF5IFR1cmtleSBpcy' THEN 'hard'
    WHEN 'otd-VGhlIHByZWZpeCBTaW5vLSAoQXMgaW4gU2luby1BbWVyaWNhbi' THEN 'easy'
    WHEN 'otd-VGhlIHN1cmZhY2UgYXJlYSBvZiBSdXNzaWEgaXMgc2xpZ2h0bH' THEN 'hard'
    WHEN 'otd-VGhlIHR3byBsYXJnZXN0IGV0aG5pYyBncm91cHMgb2YgQmVsZ2' THEN 'easy'
    WHEN 'otd-VGhlIHRoaXJkIGxhcmdlc3QgY291bnRyeSAoYnkgc3F1YXJlIG' THEN 'hard'
    WHEN 'otd-VGhlIHRpdGxlIG9mIHRoZSAxOTY5IGZpbG0gJnF1b3Q7S3Jha2' THEN 'hard'
    WHEN 'otd-VW50aWwgMTkzOSwgTGFvcyB3YXMgY2FsbGVkIFNpYW0u' THEN 'medium'
    WHEN 'otd-JnF1b3Q7VGhlIEJpZyBCYW5nIFRoZW9yeSZxdW90OyB3YXMgZm' THEN 'medium'
    WHEN 'otd-Q291bHJvcGhvYmlhIGlzIHRoZSBpcnJhdGlvbmFsIGZlYXIgb2' THEN 'medium'
    WHEN 'otd-Q2VsaWFjIERpc2Vhc2UgaXMgYSBkaXNlYXNlIHRoYXQgZWZmZW' THEN 'medium'
    WHEN 'otd-Q2VudHJpcGV0YWwgZm9yY2UgaXMgYW4gYXBwYXJlbnQgZm9yY2' THEN 'hard'
    WHEN 'otd-QSBwZXJzb24gY2FuIGdldCBzdW5idXJuZWQgb24gYSBjbG91ZH' THEN 'easy'
    WHEN 'otd-QW4gQXN0cm9ub21pY2FsIFVuaXQgaXMgdGhlIGRpc3RhbmNlIG' THEN 'medium'
    WHEN 'otd-QW4gZXhvdGhlcm1pYyByZWFjdGlvbiBpcyBhIGNoZW1pY2FsIH' THEN 'medium'
    WHEN 'otd-QW5hdG9teSBjb25zaWRlcnMgdGhlIGZvcm1zIG9mIG1hY3Jvc2' THEN 'easy'
    WHEN 'otd-QWJvdXQgaG93IG9sZCBpcyBFYXJ0aD8=' THEN 'easy'
    WHEN 'otd-QWxiZXJ0IEVpbnN0ZWluIHdvbiBhIG5vYmxlIHByaXplIGZvci' THEN 'medium'
    WHEN 'otd-QWxsIHRoZSBmb2xsb3dpbmcgbWV0YWwgZWxlbWVudHMgYXJlIG' THEN 'hard'
    WHEN 'otd-QWZ0ZXIgd2hpY2ggRGFuaXNoIGNpdHkgaXMgdGhlIDcydGggZW' THEN 'hard'
    WHEN 'otd-QXBwcm94aW1hdGVseSBob3cgbG9uZyBpcyBhIHllYXIgb24gVX' THEN 'hard'
    WHEN 'otd-QXQgd2hhdCB0ZW1wZXJhdHVyZSBkb2VzIHdhdGVyIGJvaWw/' THEN 'hard'
    WHEN 'otd-QXUgb24gdGhlIFBlcmlvZGljIFRhYmxlIHJlZmVycyB0byB3aG' THEN 'easy'
    WHEN 'otd-QXV0b3NvbWFsLWRvbWluYW50IENvbXBlbGxpbmcgSGVsaW8tT3' THEN 'medium'
    WHEN 'otd-R3JlYXQgV2hpdGVzIHNvbWV0aW1lcyBwZXJmb3JtIHRoZSBidW' THEN 'medium'
    WHEN 'otd-RGVpb25pemVkIHdhdGVyIGlzIHdhdGVyIHdpdGggd2hpY2ggb2' THEN 'hard'
    WHEN 'otd-Rm9saWMgYWNpZCBpcyB0aGUgc3ludGhldGljIGZvcm0gb2Ygd2' THEN 'medium'
    WHEN 'otd-RnJlZGVyaWNrIEJhbnRpbmcgYW5kIEpvaG4gTWFjbGVvZCB3b2' THEN 'easy'
    WHEN 'otd-SG93IG1hbnkgaGVhcnRzIGRvZXMgYW4gb2N0b3B1cyBoYXZlPw' THEN 'easy'
    WHEN 'otd-SG93IG1hbnkgb2ZmaWNpYWxseSByZWNvZ25pemVkIGR3YXJmIH' THEN 'hard'
    WHEN 'otd-SG93IG1hbnkgbGF3cyBvZiB0aGVybW9keW5hbWljcyBhcmUgdG' THEN 'medium'
    WHEN 'otd-SG93IG1hbnkgbGVncyBpcyBpdCBiaW9sb2dpY2FsbHkgaW1wb3' THEN 'medium'
    WHEN 'otd-SG93IG1hbnkgbW9vbnMgZG9lcyBQbHV0byBoYXZlPw==' THEN 'hard'
    WHEN 'otd-SG93IG1hbnkgcHJvdG9ucyBhcmUgaW4gYW4gb3h5Z2VuIGF0b2' THEN 'medium'
    WHEN 'otd-SG93IG1hbnkgdGVldGggZG9lcyB0aGUgYXZlcmFnZSBhZHVsdC' THEN 'easy'
    WHEN 'otd-SG93IG1hbnkgY2hyb21vc29tZXMgYXJlIGluIHlvdXIgYm9keS' THEN 'medium'
    WHEN 'otd-SHVtYW4gY2VsbHMgdHlwaWNhbGx5IGhhdmUgaG93IG1hbnkgY2' THEN 'medium'
    WHEN 'otd-SW4gaHVtYW4gYmlvbG9neSwgYSBjaXJjYWRpdW0gcmh5dGhtIH' THEN 'easy'
    WHEN 'otd-SW4gdGhlIHBlcmlvZGljIHRhYmxlLCBQb3Rhc3NpdW0mIzAzOT' THEN 'easy'
    WHEN 'otd-SW4gQ2hlbWlzdHJ5LCBob3cgbWFueSBpc29tZXJzIGRvZXMgQn' THEN 'hard'
    WHEN 'otd-SWduZW91cyByb2NrcyBhcmUgZm9ybWVkIGJ5IGV4Y2Vzc2l2ZS' THEN 'medium'
    WHEN 'otd-SXQgd2FzIG9uY2UgYmVsaWV2ZWQgdGhhdCBpbmplY3Rpbmcgc2' THEN 'medium'
    WHEN 'otd-T24gd2hpY2ggbWlzc2lvbiBkaWQgdGhlIFNwYWNlIFNodXR0bG' THEN 'hard'
    WHEN 'otd-TmF0dXJhbGx5IG9jY3VyaW5nIHVyYW5pdW0gcHJpbWFyaWx5IG' THEN 'hard'
    WHEN 'otd-TXlvcGlhIGlzIHRoZSBzY2llbnRpZmljIHRlcm0gZm9yIHdoaW' THEN 'hard'
    WHEN 'otd-U3VnYXIgY29udGFpbnMgZmF0Lg==' THEN 'easy'
    WHEN 'otd-UG5ldW1vbm91bHRyYW1pY3Jvc2NvcGljc2lsaWNvdm9sY2Fub2' THEN 'hard'
    WHEN 'otd-V2F0ZXIgYWx3YXlzIGJvaWxzIGF0IDEwMCZkZWc7QywgMjEyJm' THEN 'medium'
    WHEN 'otd-V2hhdCB0ZXJtIGlzIGJlc3QgYXNzb2NpYXRlZCB3aXRoIFNpZ2' THEN 'easy'
    WHEN 'otd-V2hhdCBhcmUgaHVtYW4gbmFpbHMgbWFkZSBvZj8=' THEN 'easy'
    WHEN 'otd-V2hhdCBhcmUgdGhlIHNtYWxsZXN0IGJsb29kIHZlc3NlbHMgaW' THEN 'easy'
    WHEN 'otd-V2hhdCBjYXVzZXMgdGhlIHNvdW5kIG9mIGEgaGVhcnRiZWF0Pw' THEN 'medium'
    WHEN 'otd-V2hhdCBjZWxsIG9yZ2FuZWxsZSBpcyBrbm93biBhcyAmcXVvdD' THEN 'easy'
    WHEN 'otd-V2hhdCBkaWQgR3JlZ29yeSBNZW5kZWwgdXNlIHRvIHRlc3QgZ2' THEN 'medium'
    WHEN 'otd-V2hhdCBkb2VzIENQUiwgdGhlIGVtZXJnZW5jeSBwcm9jZWR1cm' THEN 'easy'
    WHEN 'otd-V2hhdCBkb2VzIExBU0VSIHN0YW5kIGZvcj8=' THEN 'hard'
    WHEN 'otd-V2hhdCBkb2VzIHRoZSB5ZWxsb3cgZGlhbW9uZCBvbiB0aGUgTk' THEN 'hard'
    WHEN 'otd-V2hhdCBkb2VzIHRoZSBzY2llbnRpZmljIG5hbWUgb2YgdGhlIE' THEN 'medium'
    WHEN 'otd-V2hhdCBkbyB5b3Ugc3R1ZHkgaWYgeW91IGFyZSBzdHVkeWluZy' THEN 'easy'
    WHEN 'otd-V2hhdCBpcyB0aGUgaG90dGVzdCBwbGFuZXQgaW4gdGhlIFNvbG' THEN 'medium'
    WHEN 'otd-V2hhdCBpcyB0aGUgaGFsZi1saWZlIG9mIFVyYW5pdW0tMjM1Pw' THEN 'hard'
    WHEN 'otd-V2hhdCBpcyB0aGUgb2ZmaWNpYWwgbmFtZSBvZiB0aGUgc3Rhci' THEN 'hard'
    WHEN 'otd-V2hhdCBpcyB0aGUgbGFyZ2VzdCBsaXZpbmcgb3JnYW5pc20gY3' THEN 'hard'
    WHEN 'otd-V2hhdCBpcyB0aGUgbW9sZWN1bGFyIGZvcm11bGEgb2YgdGhlIG' THEN 'hard'
    WHEN 'otd-V2hhdCBpcyB0aGUgbW9sZWN1bGFyIGZvcm11bGEgb2YgR2x1Y2' THEN 'medium'
    WHEN 'otd-V2hhdCBpcyB0aGUgbW9sZWN1bGFyIGZvcm11bGEgb2YgT3pvbm' THEN 'easy'
    WHEN 'otd-V2hhdCBpcyB0aGUgbW9zdCBwb3RlbnQgdG94aW4ga25vd24/' THEN 'medium'
    WHEN 'otd-V2hhdCBpcyB0aGUgbWVkaWNhbCB0ZXJtIGZvciBsb3cgYmxvb2' THEN 'hard'
    WHEN 'otd-V2hhdCBpcyB0aGUgc2FtZSBpbiBDZWxzaXVzIGFuZCBGYWhyZW' THEN 'medium'
    WHEN 'otd-V2hhdCBpcyB0aGUgc2NpZW50aWZpYyB0ZXJtIGZvciAmIzAzOT' THEN 'hard'
    WHEN 'otd-V2hhdCBpcyB0aGUgc2NpZW50aWZpYyBuYW1lIG9mIHRoZSBrbm' THEN 'medium'
    WHEN 'otd-V2hhdCBpcyB0aGUgc2NpZW50aWZpYyBuYW1lIGZvciB0aGUgZX' THEN 'medium'
    WHEN 'otd-V2hhdCBpcyB0aGUgc3BlZWQgb2YgbGlnaHQgaW4gYSB2YWN1dW' THEN 'hard'
    WHEN 'otd-V2hhdCBpcyB0aGUgc3RhbmRhcmQgU0kgdW5pdCBmb3IgdGVtcG' THEN 'medium'
    WHEN 'otd-V2hhdCBpcyB0aGUgc3RhbmRhcmQgYXRvbWljIHdlaWdodCBvZi' THEN 'hard'
    WHEN 'otd-V2hhdCBpcyB0aGUgdW5pdCBvZiBlbGVjdHJpY2FsIGNhcGFjaX' THEN 'hard'
    WHEN 'otd-V2hhdCBpcyB0aGUgdW5pdCBvZiBlbGVjdHJpY2FsIHJlc2lzdG' THEN 'medium'
    WHEN 'otd-V2hhdCBpcyB0aGUgTGlubmVhbiBuYW1lIG9mIHRoZSBkb21lc3' THEN 'hard'
    WHEN 'otd-V2hhdCBpcyB0aGUgYXRvbWljIG1hc3Mgb2YgQ2FyYm9uPw==' THEN 'medium'
    WHEN 'otd-V2hhdCBpcyB0aGUgYXRvbWljIG51bWJlciBvZiB0aGUgZWxlbW' THEN 'hard'
    WHEN 'otd-V2hhdCBpcyB0aGUgZWxlbWVudGFsIHN5bWJvbCBmb3IgbWVyY3' THEN 'medium'
    WHEN 'otd-V2hhdCBpcyBhbiBleGFtcGxlIG9mIGEgYmFjdGVyaWFsIHBhdG' THEN 'medium'
    WHEN 'otd-V2hhdCBpcyBIeXBlcm5hdHJlbWlhPw==' THEN 'hard'
    WHEN 'otd-V2hhdCBpcyByYWRpYXRpb24gbWVhc3VyZWQgaW4/' THEN 'hard'
    WHEN 'otd-V2hhdCBtaW5lcmFsIGhhcyB0aGUgbG93ZXN0IG51bWJlciBvbi' THEN 'hard'
    WHEN 'otd-V2hhdCBtZWRpY2F0aW9uIHdhcyBvbmNlIGNvbW1vbmx5IHVzZW' THEN 'hard'
    WHEN 'otd-V2hhdCBudWNsZW90aWRlIHBhaXJzIHdpdGggZ3VhbmluZT8=' THEN 'medium'
    WHEN 'otd-V2hhdCBuYW1lIGlzIGdpdmVuIHRvIGFsbCBiYWJ5IG1hcnN1cG' THEN 'medium'
    WHEN 'otd-V2hhdCBwb2x5bWVyIGlzIHVzZWQgdG8gbWFrZSBDRHMsIHNhZm' THEN 'hard'
    WHEN 'otd-V2hhdCBwYXJ0IG9mIHRoZSBib2R5IHByb2R1Y2VzIGluc3VsaW' THEN 'easy'
    WHEN 'otd-V2hhdCBzdGFnZSBvZiBkZXZlbG9wbWVudCBkbyB0aGUgbWFqb3' THEN 'hard'
    WHEN 'otd-V2hlcmUgaW4gdGhlIGh1bWFuIGJvZHkgaXMgdGhlIFBpbmVhbC' THEN 'medium'
    WHEN 'otd-V2hlcmUgaXMgdGhlIEdsdXRldXMgTWF4aW11cyBtdXNjbGUgbG' THEN 'easy'
    WHEN 'otd-V2hlcmUgZGlkIHRoZSBHcmVhdCBTdG9ybSBvZiAxOTg3IG1ha2' THEN 'hard'
    WHEN 'otd-V2hlcmUgZGlkIHRoZSBkb2cgYnJlZWQgJnF1b3Q7Q2hpaHVhaH' THEN 'easy'
    WHEN 'otd-V2hpY2ggaXMgdGhlIGNoZW1pY2FsIG5hbWUgb2YgSDJPPw==' THEN 'medium'
    WHEN 'otd-V2hpY2ggb2YgdGhlc2UgaXMgdXNlZCB0byBzaG93IHRoYXQgRW' THEN 'medium'
    WHEN 'otd-V2hpY2ggb2YgdGhlc2UgaXMgTk9UIGEgcGFydCBvZiB0aGUgc3' THEN 'hard'
    WHEN 'otd-V2hpY2ggb2YgdGhlc2UgaXMgTk9UIGEgYm9uZSBmb3VuZCBpbi' THEN 'easy'
    WHEN 'otd-V2hpY2ggb2YgdGhlc2UgaXMgYSB0eXBlIG9mIHN0cmV0Y2gvZG' THEN 'hard'
    WHEN 'otd-V2hpY2ggb2YgdGhlc2UgaXMgYSBzZW1pY29uZHVjdG9yIGFtcG' THEN 'medium'
    WHEN 'otd-V2hpY2ggb2YgdGhlc2Ugc3RhcnMgaXMgdGhlIGxhcmdlc3Q/' THEN 'hard'
    WHEN 'otd-V2hpY2ggb2YgdGhlc2UgY2hlbWljYWwgY29tcG91bmRzIGlzIE' THEN 'easy'
    WHEN 'otd-V2hpY2ggb2YgdGhlc2UgY2hvaWNlcyBpcyBub3Qgb25lIG9mIH' THEN 'hard'
    WHEN 'otd-V2hpY2ggb2YgdGhlc2UgYW5pbWFscyBiZWxvbmdzIGluIGNsYX' THEN 'medium'
    WHEN 'otd-V2hpY2ggb2YgdGhlc2UgZWxlbWVudHMgb24gdGhlIFBlcmlvZG' THEN 'easy'
    WHEN 'otd-V2hpY2ggb2YgdGhlIGZvbGxvd2luZyBibG9vZCB2ZXNzZWxzIG' THEN 'medium'
    WHEN 'otd-V2hpY2ggb2YgdGhlIGZvbGxvd2luZyBpcyBhIG1ham9yIG11c2' THEN 'easy'
    WHEN 'otd-V2hpY2ggb2YgdGhlIGZvbGxvd2luZyBpcyBjb25zaWRlcmVkIG' THEN 'medium'
    WHEN 'otd-V2hpY2ggb2YgdGhlIGZvbGxvd2luZyBwbGFzdGljIGlzIGNvbW' THEN 'easy'
    WHEN 'otd-V2hpY2ggbW9vbiBpcyB0aGUgb25seSBzYXRlbGxpdGUgaW4gb3' THEN 'medium'
    WHEN 'otd-V2hpY2ggc2NpZW50aWZpYyB1bml0IGlzIG5hbWVkIGFmdGVyIG' THEN 'medium'
    WHEN 'otd-V2hpY2ggcG9ydGlvbiBvZiB0aGUgTWFyaWp1YW5hIHBsYW50IH' THEN 'easy'
    WHEN 'otd-V2hpY2ggcGFydCBvZiB0aGUgYm9keSBkb2VzIGdsYXVjb21hIG' THEN 'easy'
    WHEN 'otd-V2hpY2ggcGxhbmV0IGluIHRoZSBTb2xhciBTeXN0ZW0gaXMgdG' THEN 'easy'
    WHEN 'otd-V2hpY2ggdHlwZSBvZiByb2NrIGlzIGNyZWF0ZWQgYnkgaW50ZW' THEN 'medium'
    WHEN 'otd-V2hpY2ggY2hlbWljYWwgZWxlbWVudCB3YXMgb3JpZ2luYWxseS' THEN 'hard'
    WHEN 'otd-V2hpY2ggY2hlbWljYWwgZWxlbWVudCBoYXMgdGhlIGxvd2VzdC' THEN 'hard'
    WHEN 'otd-V2hpY2ggZWxlbWVudCBoYXMgdGhlIGhpZ2hlc3QgbWVsdGluZy' THEN 'hard'
    WHEN 'otd-V2hvIG1hZGUgdGhlIGRpc2NvdmVyeSBvZiBYLXJheXM/' THEN 'easy'
    WHEN 'otd-VGhlICZxdW90O0d5bXBpZSBTdGluZ2VyJnF1b3Q7IGlzIHRoZS' THEN 'hard'
    WHEN 'otd-VGhlICZxdW90O1RpYmlhJnF1b3Q7IGlzIGZvdW5kIGluIHdoaW' THEN 'easy'
    WHEN 'otd-VGhlIEF4aW9tIG9mIFByZXZlbnRpdmUgTWVkaWNpbmUgc3RhdG' THEN 'hard'
    WHEN 'otd-VGhlIEZyZW5jaCBzY2llbnRpc3RzIExvdWlzIFBhc3RldXIgYW' THEN 'easy'
    WHEN 'otd-VGhlIFN1biBjb25zaXN0cyBvZiBtb3N0bHkgd2hpY2ggdHdvIG' THEN 'easy'
    WHEN 'otd-VGhlIG1lZGljYWwgdGVybSBmb3IgdGhlIGJlbGx5IGJ1dHRvbi' THEN 'hard'
    WHEN 'otd-VGhlIG1lZGljYWwgY29uZGl0aW9uIG9zdGVvcG9yb3NpcyBhZm' THEN 'easy'
    WHEN 'otd-VGhlIG1vb25zLCBNaXJhbmRhLCBBcmllbCwgVW1icmllbCwgVG' THEN 'hard'
    WHEN 'otd-VGhlIGFzdGVyb2lkIGJlbHQgaXMgbG9jYXRlZCBiZXR3ZWVuIH' THEN 'medium'
    WHEN 'otd-VGhlIGJpZ2dlc3QgZGlzdGluY3Rpb24gYmV0d2VlbiBhIGV1a2' THEN 'medium'
    WHEN 'otd-VGhlIGNoZW1pY2FsIGVsZW1lbnQgTGl0aGl1bSBpcyBuYW1lZC' THEN 'medium'
    WHEN 'otd-VGhlIGVsZW1lbnQgaW52b2x2ZWQgaW4gbWFraW5nIGh1bWFuIG' THEN 'medium'
    WHEN 'otd-VGhlIHdvcmQgJnF1b3Q7c2NpZW5jZSZxdW90OyBzdGVtcyBmcm' THEN 'medium'
    WHEN 'otd-VGV0c3V5YSBGdWppdGEgd2FzIGEgc2NpZW50aXN0IHRoYXQgZG' THEN 'hard'
    WHEN 'otd-VXB3ZWxsaW5nIGluIHRoZSBvY2VhbiBwcm92aWRlcyBjb2xkZX' THEN 'hard'
    ELSE "difficulty"
END
WHERE "sourceId" IN (
    'otd-JnF1b3Q7TWluZWNyYWZ0JnF1b3Q7IHdhcyByZWxlYXNlZCBmcm',
    'otd-JnF1b3Q7U29uaWMgdGhlIEhlZGdlaG9nIDImcXVvdDsgb3JpZ2',
    'otd-JnF1b3Q7Um9sbGVyY29hc3RlciBUeWNvb24mcXVvdDsgd2FzIH',
    'otd-JnF1b3Q7UmVzaWRlbnQgRXZpbCA3JnF1b3Q7IGlzIHRoZSBmaX',
    'otd-JnF1b3Q7VG9tYiBSYWlkZXImcXVvdDsgaWNvbiBMYXJhIENyb2',
    'otd-JnF1b3Q7VGhlIFBvdGF0byBTYWNrJnF1b3Q7IHdhcyBhIGNvbG',
    'otd-Q2FwY29tJiMwMzk7cyBzdXJ2aXZhbCBob3Jyb3IgdGl0bGUgRG',
    'otd-QmlnIHRoZSBDYXQgaXMgYSBwbGF5YWJsZSBjaGFyYWN0ZXIgaW',
    'otd-QmVmb3JlIGl0JiMwMzk7cyByZWRlc2lnbiBvZiB0aGUgY29tcG',
    'otd-QnkgaG93IG1hbnkgbWludXRlcyBhcmUgeW91IGxhdGUgdG8gd2',
    'otd-QW5hIHdhcyBhZGRlZCBhcyBhIG5ldyBoZXJvIGZvciB0aGUgZ2',
    'otd-QXBlcnR1cmUgU2NpZW5jZSBDRU8gQ2F2ZSBKb2huc29uIGlzIH',
    'otd-QXMgb2YgRmVicnVhcnkgMjAxOSwgdGhlICZxdW90O0RvbmtleS',
    'otd-R29yZG9uIEZyZWVtYW4gaXMgc2FpZCB0byBoYXZlIGJ1cm50IG',
    'otd-R29yZG9uIEZyZWVtYW4sIHRoZSBwcm90YWdvbmlzdCBvZiAmcX',
    'otd-R3JhbmQgVGhlZnQgQXV0byBWIGlzIHRoZSBmaWZ0ZWVudGggaW',
    'otd-RG9raSBEb2tpIExpdGVyYXR1cmUgQ2x1YiB3YXMgZGV2ZWxvcG',
    'otd-RG9ua2V5IEtvbmcgd2FzIG9yaWdpbmFsbHkgc2V0IHRvIGJlIG',
    'otd-RGF2aWQgQmFzenVja2kgd2FzIGEgY28tZm91bmRlciBvZiBST0',
    'otd-RGFuZ2Fucm9ucGEgMjogR29vZGJ5ZSBEZXNwYWlyIGZlYXR1cm',
    'otd-RGV1cyBFeCAoMjAwMCkgZG9lcyBub3QgZmVhdHVyZSB0aGUgV2',
    'otd-RHJhZ29uRm9yY2UmIzAzOTtzICYjMDM5O1Rocm91Z2ggdGhlIE',
    'otd-RHVyaW5nIHRoZSBldmVudHMgb2YgSGFsZi1MaWZlOiBPcHBvc2',
    'otd-Rm9ydG5pdGUgd2FzIG9yaWdpbmFsbHkgaW50ZW5kZWQgdG8gYm',
    'otd-RmF1c3QgaXMgYSBwbGF5YWJsZSBjaGFyYWN0ZXIgaW4gJnF1b3',
    'otd-RnJvbSB0aGUgTWVtZSBDdWx0dXJlLCB3aGljaCBNYXJpbyBnYW',
    'otd-RW5nbGlzaCBuZXcgd2F2ZSBtdXNpY2lhbiBHYXJ5IE51bWFuIG',
    'otd-RWxsZW4gTWNMYWluLCB0aGUgdm9pY2Ugb2YgR0xhRE9TIGluIH',
    'otd-RXhjbHVkaW5nIHRoZWlyIGluc3RydWN0b3IsIGhvdyBtYW55IG',
    'otd-S2lsbGluZyBGbG9vciBzdGFydGVkIGFzIGEgbW9kIGZvciB3aG',
    'otd-SG93IG1hbnkgbm9ybWFsIGVuZGluZ3MgYXJlIHRoZXJlIGluIE',
    'otd-SG93IG1hbnkgbWV0YWwgYmFycyBkb2VzIGl0IHRha2UgdG8gc2',
    'otd-SG93IG1hbnkgc3RhcnMgYXJlIHRoZXJlIHRvIGNvbGxlY3QgaW',
    'otd-SG93IG1hbnkgcGVybWFuZW50IGNvbXBhbmlvbnMgYXJlIHRoZX',
    'otd-SG93IG1hbnkgcGxheWFibGUgY2hhcmFjdGVycyBhcmUgdGhlcm',
    'otd-SG93IG1hbnkgcmVndWxhciBTdW5rZW4gU2VhIFNjcm9sbHMgYX',
    'otd-SG93IG1hbnkgdGltZXMgZG8geW91IGZpZ2h0IEdpbGdhbWVzaC',
    'otd-SG93IG1hbnkgem9tYmllcyBuZWVkIHRvIGJlIGtpbGxlZCB0by',
    'otd-SG93IG1hbnkgTXVkb2tvbnMgYXJlIHJlc2N1YWJsZSBpbiAmcX',
    'otd-SG93IG1hbnkgY29udHJvbGxlcnMgY291bGQgYSBOaW50ZW5kby',
    'otd-SG93IG1hbnkgY29waWVzIG9mIHRoZSBub3RvcmlvdXMgRS5ULi',
    'otd-SG93IG1hbnkgY2FyYm9uIGNhcnMgYXJlIHRoZXJlIGluIEJ1cm',
    'otd-SG93IG1hbnkgY2xhc3NlcyBhcmUgdGhlcmUgaW4gVGVhbSBGb3',
    'otd-SG93IG1hbnkgZ2FtZXMgaW4gdGhlIENyYXNoIEJhbmRpY29vdC',
    'otd-SG93IG1hbnkgZ2FtZXMgYXJlIHRoZXJlIGluIHRoZSAmcXVvdD',
    'otd-SG93IG1hbnkgZGlmZmVyZW50IG5vdGVzIGlzIHRoZSB0dW5lLC',
    'otd-SG93IGxvbmcgYXJlIGFsbCB0aGUgY3V0c2NlbmVzIGZyb20gTW',
    'otd-SGFsZi1MaWZlIGJ5IFZhbHZlIHVzZXMgdGhlIEdvbGRTcmMgZ2',
    'otd-SnVzdCBDYXVzZSAyIHdhcyBtYWlubHkgc2V0IGluIHdoYXQgZm',
    'otd-SW4gd2hhdCB5ZWFyIHdhcyAmcXVvdDtBbnRpY2hhbWJlciZxdW',
    'otd-SW4gd2hhdCB5ZWFyIHdhcyAmcXVvdDtNZXRhbCBHZWFyIFNvbG',
    'otd-SW4gd2hhdCB5ZWFyIHdhcyB0aGUgb3JpZ2luYWwgU29uaWMgdG',
    'otd-SW4gd2hhdCB5ZWFyIHdhcyB0aGUgZ2FtZSAmcXVvdDtGVEw6IE',
    'otd-SW4gd2hhdCB5ZWFyIHdhcyB0aGUgZ2FtZSAmcXVvdDtGYWxsb3',
    'otd-SW4gd2hhdCB5ZWFyIHdhcyB0aGUgZmlyc3QgJnF1b3Q7TWFzcy',
    'otd-SW4gd2hhdCB5ZWFyIHdhcyB0aGUgZmlyc3QgZVNwb3J0cyBjb2',
    'otd-SW4gd2hhdCB5ZWFyIHdhcyBHYXJyeSYjMDM5O3MgTW9kIHJlbG',
    'otd-SW4gd2hhdCB5ZWFyIHdhcyBIZWFydGhzdG9uZSByZWxlYXNlZD',
    'otd-SW4gd2hhdCB5ZWFyIHdlcmUgc2NyZWVuc2hvdHMgYWRkZWQgdG',
    'otd-SW4gd2hhdCB5ZWFyIHdlcmUgYWNoaXZlbWVudHMgYWRkZWQgdG',
    'otd-SW4gd2hhdCBIYWxmLUxpZmUgZXhwYW5zaW9uIGNhbiB5b3UgZm',
    'otd-SW4gd2hpY2ggb3JkZXIgZG8geW91IG5lZWQgdG8gaGl0IHNvbW',
    'otd-SW4gd2hpY2ggbWFsbCBkb2VzICZxdW90O0RlYWQgUmlzaW5nJn',
    'otd-SW4gd2hpY2ggeWVhciBkaWQgdGhlIG9yaWduYWwgU2ltcyBnYW',
    'otd-SW4gd2hpY2ggeWVhciBkaWQgdGhlIGZpcnN0IE1vbnN0ZXIgSH',
    'otd-SW4gd2hpY2ggJnF1b3Q7Q2FsbCBvZiBEdXR5JnF1b3Q7IGdhbW',
    'otd-SW4gd2hpY2ggTWFyaW8gZ2FtZSBkaWQgdGhlIE1lZ2EgTXVzaH',
    'otd-SW4gd2hpY2ggY291bnRyeSYjMDM5O3MgdmVyc2lvbiBvZiBIYW',
    'otd-SW4gd2hpY2ggZ2FtZSBkaWQgdGhlIGNoYXJhY3RlciAmcXVvdD',
    'otd-SW4gd2hpY2ggZ2FtZSBkb2VzIGEgY2hhcmFjdGVyIHNheSwgJn',
    'otd-SW4gdGhlICZxdW90O05lcHR1bmlhJnF1b3Q7IHNlcmllcyB3aG',
    'otd-SW4gdGhlICZxdW90O0hhbG8mcXVvdDsgc2VyaWVzLCB3aGF0IG',
    'otd-SW4gdGhlICZxdW90O0hhbGYtTGlmZSZxdW90OyBzZXJpZXMsIC',
    'otd-SW4gdGhlICZxdW90O0NhbGwgT2YgRHV0eTogWm9tYmllcyZxdW',
    'otd-SW4gdGhlICZxdW90O0RldmlsIE1heSBDcnkmcXVvdDsgZnJhbm',
    'otd-SW4gdGhlICZxdW90O1Bpa21pbiZxdW90OyBzZXJpZXMsIHdoYX',
    'otd-SW4gdGhlICZxdW90O1dvcm1zJnF1b3Q7IHNlcmllcyBvZiB2aW',
    'otd-SW4gdGhlICZxdW90O1MuVC5BLkwuSy5FLlIuJnF1b3Q7IHNlcm',
    'otd-SW4gdGhlIDE5ODBzLCBhIHNlcnZpY2UgY2FsbGVkIEdhbWVsaW',
    'otd-SW4gdGhlIDIwMDAgdmlkZW8gZ2FtZSAmcXVvdDtDcmltc29uIF',
    'otd-SW4gdGhlIDIwMDIgdmlkZW8gZ2FtZSAmcXVvdDtLaW5nZG9tIE',
    'otd-SW4gdGhlIDIwMTUgUlBHICZxdW90O1VuZGVydGFsZSZxdW90Oy',
    'otd-SW4gdGhlIE1hc3MgRWZmZWN0IHRyaWxvZ3ksIHdobyBpcyB0aG',
    'otd-SW4gdGhlIE1hcmlvIHNlcmllcywgd2hpY2ggZ2FtZSBpbnRyb2',
    'otd-SW4gdGhlIE1vbnN0ZXIgSHVudGVyIFNlcmllcywgaXQgaXMgcG',
    'otd-SW4gdGhlIE1vbnN0ZXIgSHVudGVyIFNlcmllcywgRy1SYW5rIG',
    'otd-SW4gdGhlIE1vcnRhbCBLb21iYXQgc2VyaWVzIHRoZSAmcXVvdD',
    'otd-SW4gdGhlIE5pbnRlbmRvIERTIGdhbWUgJiMwMzk7R2hvc3QgVH',
    'otd-SW4gdGhlIEFSUEcgJnF1b3Q7UGF0aCBvZiBFeGlsZSwmcXVvdD',
    'otd-SW4gdGhlIEFuaW1hbCBDcm9zc2luZyBzZXJpZXMsIHdoaWNoIG',
    'otd-SW4gdGhlIEhhbG8gc2VyaWVzLCB3aGF0IGZsZWV0IHdhcyBUaG',
    'otd-SW4gdGhlIEhhbG8gc2VyaWVzLCB3aGljaCBlcmEgb2YgU1BBUl',
    'otd-SW4gdGhlIEhhbGYtTGlmZSBmcmFuY2hpc2UsIHdoYXQgaXMgdG',
    'otd-SW4gdGhlIEphY2tib3ggcGFydHkgZ2FtZSBNb25zdGVyIFNlZW',
    'otd-SW4gdGhlIERpc2dhZWEgc2VyaWVzLCBhbnkgY2hhcmFjdGVyIG',
    'otd-SW4gdGhlIEtpbmdkb20gSGVhcnQgc2VyaWVzIHdobyBwcm92aW',
    'otd-SW4gdGhlIEZhbGxvdXQ6IE5ldyBWZWdhcyBhZGQtb24gSG9uZX',
    'otd-SW4gdGhlIEZhbGxvdXQ6IE5ldyBWZWdhcyBhZGQtb24gTG9uZX',
    'otd-SW4gdGhlIEZhbGxvdXQgc2VyaWVzLCBvbiB3aGljaCBkYXRlIG',
    'otd-SW4gdGhlIFBBWURBWSBzZXJpZXMsIHdobyBiZXRyYXllZCB0aG',
    'otd-SW4gdGhlIFBvayZlYWN1dGU7bW9uIHNlcmllcywgd2hpY2ggdH',
    'otd-SW4gdGhlIFBvcnRhbCBzZXJpZXMsIEFwZXJ0dXJlIFNjaWVuY2',
    'otd-SW4gdGhlIFJlc2lkZW50IEV2aWwgc2VyaWVzLCBMZW9uIFMuIE',
    'otd-SW4gdGhlIFlha3V6YSBzZXJpZXMgd2hvIGlzIHRoZSBEcmFnb2',
    'otd-SW4gdGhlIFN1cGVyIFNtYXNoIEJyb3MuIHNlcmllcywgd2hpY2',
    'otd-SW4gdGhlIFRlYW0gRm9ydHJlc3MgMiBjYW5vbiwgd2hhdCBkaW',
    'otd-SW4gdGhlIFZpZGVvIEdhbWUsIEhhbGYtbGlmZSwgd2hhdCB0eX',
    'otd-SW4gdGhlIG9yaWdpbmFsIERPT00gKDE5OTMpIHdoaWNoIG9mIH',
    'otd-SW4gdGhlIGdhbWUgc2VyaWVzICZxdW90O1RoZSBMZWdlbmQgb2',
    'otd-SW4gdGhlIGdhbWUgJnF1b3Q7Q2F2ZSBTdG9yeSwmcXVvdDsgd2',
    'otd-SW4gdGhlIGdhbWUgJnF1b3Q7REVMVEFSVU5FJnF1b3Q7LCB3aG',
    'otd-SW4gdGhlIGdhbWUgJnF1b3Q7RGVzdGlueSwmcXVvdDsgdGhlIH',
    'otd-SW4gdGhlIGdhbWUgJnF1b3Q7U29uaWMgdGhlIEhlZGdlaG9nIC',
    'otd-SW4gdGhlIGdhbWUgJnF1b3Q7U3VibmF1dGljYSZxdW90Oywgd2',
    'otd-SW4gdGhlIGdhbWUgJnF1b3Q7U3VibmF1dGljYSZxdW90OywgYS',
    'otd-SW4gdGhlIGdhbWUgJnF1b3Q7VGhlIFNpbXMmcXVvdDssIGhvdy',
    'otd-SW4gdGhlIGdhbWUgJnF1b3Q7VW5kZXJ0YWxlJnF1b3Q7LCB3aG',
    'otd-SW4gdGhlIGdhbWUgQmF0dGxlYmxvY2sgVGhlYXRlciwgd2hhdC',
    'otd-SW4gdGhlIGdhbWUgRGFuZ2Fucm9ucGE6IEhhcHB5IFRyaWdnZX',
    'otd-SW4gdGhlIGdhbWUgRGFyayBTb3Vscywgd2hhdCBpcyB0aGUgbm',
    'otd-SW4gdGhlIGdhbWUgRGVhZCBieSBEYXlsaWdodCwgdGhlIGtpbG',
    'otd-SW4gdGhlIGdhbWUgRGVzdGlueSwgd2hvIHN1Y2NlZWRlZCBQZX',
    'otd-SW4gdGhlIGdhbWUgSGFsZi1MaWZlLCB3aGljaCBlbmVteSBpcy',
    'otd-SW4gdGhlIGdhbWUgT3ZlcndhdGNoLCB3aGljaCBoZXJvIG91dC',
    'otd-SW4gdGhlIGdhbWUgTnVjbGVhciBUaHJvbmUsIHdoaWNoIGNoYX',
    'otd-SW4gdGhlIGdhbWUgTnVjbGVhciBUaHJvbmUsIHdoYXQgY2hhcm',
    'otd-SW4gdGhlIGdhbWUgU29uaWMgRm9yY2VzLCB3aGljaCBvZiB0aG',
    'otd-SW4gdGhlIGdhbWUgUG9rJmVhY3V0ZTttb24gQ29ucXVlc3QsIG',
    'otd-SW4gdGhlIGdhbWUgUG9rJmVhY3V0ZTttb24gQ29ucXVlc3QsIH',
    'otd-SW4gdGhlIGdhbWUgV2FyZnJhbWUsIHdoYXQgaXMgdGhlIGJpcG',
    'otd-SW4gdGhlIGdhbWUgVGhlIFdvcmxkIEVuZHMgV2l0aCBZb3UsIG',
    'otd-SW4gdGhlIGFsdGVybmF0ZSB0aW1lbGluZSBpbiBNb3J0YWwgS2',
    'otd-SW4gdGhlIGJldGEgdmVyc2lvbiBvZiB0aGUgMTk4NiBnYW1lIC',
    'otd-SW4gdGhlIGluZGllIGZhcm1pbmcgZ2FtZSAmcXVvdDtTdGFyZG',
    'otd-SW4gdGhlIGNhbm9uICZxdW90O05lcHR1bmlhJnF1b3Q7IGdhbW',
    'otd-SW4gdGhlIGNvLW9wIHNob290ZXIgUGF5ZGF5IDIsIHdoaWNoIG',
    'otd-SW4gdGhlIGxvcmUgb2YgdGhlIFBBWURBWSBzZXJpZXMsIHdoaW',
    'otd-SW4gdGhlIGZpcnN0IExlZnQgNCBEZWFkLCB5b3UgY2FuIHBsYX',
    'otd-SW4gdGhlIGZpcnN0IGdhbWUgb2YgdGhlIFNseSBDb29wZXIgZn',
    'otd-SW4gdGhlIGZpZ2h0aW5nIGdhbWUgJnF1b3Q7U2t1bGxnaXJscy',
    'otd-SW4gdGhlIHBvcHVsYXIgTU9CQSBMZWFndWUgb2YgTGVnZW5kcy',
    'otd-SW4gdGhlIHdvcmxkIHN0cmF0ZWd5IGdhbWUgJiMwMzk7U2lkIE',
    'otd-SW4gdGhlIHJ1bGVzIG9mIHRoZSBEYW5nYW5yb25wYSBmcmFuY2',
    'otd-SW4gdGhlIHJlbWFrZSBvZiAmcXVvdDtSZXNpZGVudCBFdmlsID',
    'otd-SW4gdGhlIHN1cnZpdmFsIGhvcnJvciBnYW1lLCAmcXVvdDtDcn',
    'otd-SW4gdGhlIHRpdGxlIG9mIHRoZSBnYW1lICZxdW90O0x1aWdpJi',
    'otd-SW4gdGhlIHZpZGVvIGdhbWUgc2VyaWVzICZxdW90O0Rpc2dhZW',
    'otd-SW4gdGhlIHZpZGVvIGdhbWUgJnF1b3Q7Q2xvc2VycyBPbmxpbm',
    'otd-SW4gdGhlIHZpZGVvIGdhbWUgJnF1b3Q7Qmx1ZSBSZWZsZWN0aW',
    'otd-SW4gdGhlIHZpZGVvIGdhbWUgJnF1b3Q7U3BsYXRvb24mcXVvdD',
    'otd-SW4gdGhlIHZpZGVvIGdhbWUgJnF1b3Q7UG9zdGFsIDImcXVvdD',
    'otd-SW4gdGhlIHZpZGVvIGdhbWUgVGVhbSBGb3J0cmVzcyAyLCB3aG',
    'otd-SW4gdGhlIHZpZGVvIGdhbWUsIEhhbGYtbGlmZSwgd2hhdCBldm',
    'otd-SW4gdGhlIHZpZGVvZ2FtZSBCdWxseSwgd2hhdCBpcyB0aGUgcH',
    'otd-SW4gdmFuaWxsYSBNaW5lY3JhZnQsIHlvdSBjYW4gbWFrZSBhcm',
    'otd-SW4gJnF1b3Q7Q2FsbCBPZiBEdXR5OiBab21iaWVzJnF1b3Q7LC',
    'otd-SW4gJnF1b3Q7Q2FsbCBvZiBEdXR5OiBCbGFjayBPcHMgSUlJJn',
    'otd-SW4gJnF1b3Q7Q2l2aWxpemF0aW9uIDUmcXVvdDssIHdoaWNoIG',
    'otd-SW4gJnF1b3Q7QSBIYXQgaW4gVGltZSZxdW90Oywgd2hhdCBtdX',
    'otd-SW4gJnF1b3Q7RGV1cyBFeDogTWFua2luZCBEaXZpZGVkJnF1b3',
    'otd-SW4gJnF1b3Q7RlRMOiBGYXN0ZXIgVGhhbiBMaWdodCZxdW90Oy',
    'otd-SW4gJnF1b3Q7RmFsbG91dCA0JnF1b3Q7IHdoaWNoIGZhY3Rpb2',
    'otd-SW4gJnF1b3Q7RmFsbG91dCA0JnF1b3Q7LCB3aGF0IGlzIHRoZS',
    'otd-SW4gJnF1b3Q7SGFsbyAyJnF1b3Q7LCB3aGF0IGlzIHRoZSBuYW',
    'otd-SW4gJnF1b3Q7T3ZlcndhdGNoJnF1b3Q7LCB3aGF0IGlzIHRoZS',
    'otd-SW4gJnF1b3Q7T3ZlcndhdGNoLCZxdW90OyB3aGF0IGlzIHRoZS',
    'otd-SW4gJnF1b3Q7TGVhZ3VlIG9mIExlZ2VuZHMmcXVvdDssIHRoZX',
    'otd-SW4gJnF1b3Q7TW90aGVyIDMsJnF1b3Q7IHRoZSBiaXJkIG9uIH',
    'otd-SW4gJnF1b3Q7TWFyaW8gJmFtcDsgU29uaWMgYXQgdGhlIE9seW',
    'otd-SW4gJnF1b3Q7TWluZWNyYWZ0JnF1b3Q7LCBnb2xkIHRvb2xzIG',
    'otd-SW4gJnF1b3Q7U29uaWMgQWR2ZW50dXJlJnF1b3Q7LCB5b3UgYX',
    'otd-SW4gJnF1b3Q7U3BhY2UgU3RhdGlvbiAxMyZxdW90OywgIHRoZS',
    'otd-SW4gJnF1b3Q7U3RhcmJvdW5kJnF1b3Q7LCB0aGUgdHJhY2sgcG',
    'otd-SW4gJnF1b3Q7U3VwZXIgTWFyaW8gM0QgV29ybGQmcXVvdDssIH',
    'otd-SW4gJnF1b3Q7U3VwZXIgTWFyaW8gV29ybGQmcXVvdDssIHRoZS',
    'otd-SW4gJnF1b3Q7UFVCQVRUTEVHUk9VTkRTJnF1b3Q7IHdoaWNoIG',
    'otd-SW4gJnF1b3Q7UG9rJmVhY3V0ZTttb24gU3VuIGFuZCBNb29uJn',
    'otd-SW4gJnF1b3Q7UG9ydGFsIDImcXVvdDssIENhdmUgSm9obnNvbi',
    'otd-SW4gJnF1b3Q7UGhhbnRhc3kgU3RhciBPbmxpbmUgMiZxdW90Oy',
    'otd-SW4gJnF1b3Q7UGhvZW5peCBXcmlnaHQ6IEFjZSBBdHRvcm5leS',
    'otd-SW4gJnF1b3Q7UmVzaWRlbnQgRXZpbCAyJnF1b3Q7LCB3aGF0IG',
    'otd-SW4gJnF1b3Q7UmVzaWRlbnQgRXZpbCAyJnF1b3Q7LCB3aGljaC',
    'otd-SW4gJnF1b3Q7V2FyaGFtbWVyOiBFbmQgVGltZXMgLSBWZXJtaW',
    'otd-SW4gJnF1b3Q7VG9ueSBIYXdrJiMwMzk7cyBVbmRlcmdyb3VuZC',
    'otd-SW4gJnF1b3Q7VGhlIEJpbmRpbmcgb2YgSXNhYWMmcXVvdDssIH',
    'otd-SW4gJnF1b3Q7VGhlIEVsZGVyIFNjcm9sbHMgMzogTW9ycm93aW',
    'otd-SW4gJnF1b3Q7VGhlIExlZ2VuZCBvZiBaZWxkYTogT2NhcmluYS',
    'otd-SW4gJnF1b3Q7VGhlIFNpbXMmcXVvdDsgc2VyaWVzLCB0aGUgbW',
    'otd-SW4gJnF1b3Q7VW5kZXJ0YWxlJnF1b3Q7LCBob3cgbWFueSBtYW',
    'otd-SW4gJnF1b3Q7WGVub2JsYWRlIENocm9uaWNsZXMgMiZxdW90Oy',
    'otd-SW4gJnF1b3Q7WW8hIE5vaWQgMiwmcXVvdDsgVGhlIE5vaWQgY2',
    'otd-SW4gQ291bnRlci1TdHJpa2U6IEdsb2JhbCBPZmZlbnNpdmUsIH',
    'otd-SW4gQ291bnRlciBTdHJpa2U6IEdsb2JhbCBPZmZlbnNpdmUsIH',
    'otd-SW4gQ29EOiBCbGFjayBPcHMgSUlJLCB3aGF0IGlzIHRoZSBuYW',
    'otd-SW4gQ29vaywgU2VydmUsIERlbGljaW91cyEsIHdoaWNoIGZvb2',
    'otd-SW4gQ2FsbCBPZiBEdXR5OiBCbGFjayBPcHMgSUksIHdobyBpcy',
    'otd-SW4gQ2FsbCBvZiBEdXR5OiBNb2Rlcm4gV2FyZmFyZSAyLCBob3',
    'otd-SW4gQ2FsbCBvZiBEdXR5OiBVbml0ZWQgT2ZmZW5zaXZlLCB3aG',
    'otd-SW4gR3JhbmQgVGhlZnQgQXV0byBWLCB3aGF0IHdhcyBNaWNoYW',
    'otd-SW4gR3JhbmQgVGhlZnQgQXV0bzogViwgd2hhdCB3YW50ZWQgbG',
    'otd-SW4gRG90YSAyLCB3aGF0IGlzIEVhcnRoc2hha2VyJiMwMzk7cy',
    'otd-SW4gRG90YSAyLCBXcmFpdGggS2luZyB3YXMgcHJldmlvdXNseS',
    'otd-SW4gRGFuZ2Fucm9ucGE6IFRyaWdnZXIgSGFwcHkgSGF2b2MsIH',
    'otd-SW4gRGl2aW5pdHk6IE9yaWdpbmFsIFNpbiBJSSwgd2hhdCBpcy',
    'otd-SW4gRGVhZCBTcGFjZSAyLCB0aGUgJiMwMzk7SGFuZCBDYW5ub2',
    'otd-SW4gRm9yemEgTW90b3JzcG9ydCA2LCB3aGljaCBvZiB0aGVzZS',
    'otd-SW4gRmFsbG91dDogTmV3IFZlZ2FzLCB1cG9uIHN0YXJ0aW5nIG',
    'otd-SW4gRmFsbG91dDogTmV3IFZlZ2FzLCB3aGljaCBvbmUgb2YgdG',
    'otd-SW4gRml2ZSBOaWdodHMgYXQgRnJlZGR5JiMwMzk7cyAxLCBob3',
    'otd-SW4gRmluYWwgRmFudGFzeSBYSVYsIHdoYXQgaXMgdGhlIG5hbW',
    'otd-SW4gS2luZ2RvbSBIZWFydHMsIGhvdyBtYW55IG1lbWJlcnMgZG',
    'otd-SW4gSGFsZi1MaWZlIDIsIGlmIHlvdSBwbGF5IHRoZSB6b21iaW',
    'otd-SW4gSGl0bWFuOiBCbG9vZCBNb25leSwgd2hhdCBpcyB0aGUgbm',
    'otd-SW4gSGVyb2VzIG9mIHRoZSBTdG9ybSwgdGhlIEN1cnNlZCBIb2',
    'otd-SW4gT3ZlcndhdGNoLCB3aGF0IGlzIEwmdWFjdXRlO2NpbyYjMD',
    'otd-SW4gT3ZlcndhdGNoLCBob3cgb2xkIGlzIFJlaW5oYXJkdCBXaW',
    'otd-SW4gTmlnaHQgSW4gVGhlIFdvb2RzLCB3aGVyZSBkb2VzIEdyZW',
    'otd-SW4gTmVlZCBGb3IgU3BlZWQ6IE1vc3QgV2FudGVkICgyMDA1KS',
    'otd-SW4gTmVlZCBGb3IgU3BlZWQgTW9zdCBXYW50ZWQgKDIwMDUpLC',
    'otd-SW4gTmVlZCBmb3IgU3BlZWQ6IE1vc3QgV2FudGVkICgyMDA1KS',
    'otd-SW4gTmVlZCBmb3IgU3BlZWQ6IFVuZGVyZ3JvdW5kLCB3aGF0IG',
    'otd-SW4gTW9uc3RlciBIdW50ZXIgR2VuZXJhdGlvbnMsIGd1aWxkIH',
    'otd-SW4gTW9uc3RlciBIdW50ZXIgR2VuZXJhdGlvbnMsIHdoaWNoIG',
    'otd-SW4gTWluZWNyYWZ0LCB3aGF0IHR5cGVzIG9mIHNvdW5kIGZpbG',
    'otd-SW4gTWluZWNyYWZ0OiBKYXZhIEVkaXRpb24sIHdoaWNoIG9mIH',
    'otd-SW4gU2t5bGFuZGVycyBHaWFudHMsIHdoeSB3YXMgWmFwcyYjMD',
    'otd-SW4gU2xheSB0aGUgU3BpcmUsIHdoaWNoIG9mIHRoZSBmb2xsb3',
    'otd-SW4gU3BsYXRvb24sIHdoYXQgaXMgdGhlIGFnZSB0aGF0IGlua2',
    'otd-SW4gU3RhciBXYXJzOiBSZXB1YmxpYyBDb21tYW5kbyAoMjAwNS',
    'otd-SW4gUFJPVE9UWVBFIDIsIHdoaWNoIG9mIHRoZSBmb2xsb3dpbm',
    'otd-SW4gUFJPVE9UWVBFIDIuIHdobyBpcyByZWZlcnJlZCB0byBhcy',
    'otd-SW4gUG9rJmVhY3V0ZTttb24gU3VuIGFuZCBNb29uLCBhIG1hbG',
    'otd-SW4gUG9rJmVhY3V0ZTttb24sIEJ1bGJhc2F1ciBpcyB0aGUgb2',
    'otd-SW4gUG9rZW1vbiBEaWFtb25kLCBQZWFybCBhbmQgUGxhdGludW',
    'otd-SW4gUG9rZW1vbiBSZWQgJmFtcDsgQmx1ZSwgd2hhdCBpcyB0aG',
    'otd-SW4gUG9rZW1vbiwgdGhlIGFiaWxpdHkgV29uZGVyIEd1YXJkIG',
    'otd-SW4gUG9ydGFsIDIsIGhvdyBkaWQgQ0VPIG9mIEFwZXJ0dXJlIF',
    'otd-SW4gUG9ydGFsIDIsIHdoaWNoIHNvbGFyIHN5c3RlbSBib2R5IG',
    'otd-SW4gUG9ydGFsIDIsIHRoZSBpY29uaWMgY2hhcmFjdGVyIEdMYU',
    'otd-SW4gUG9ydGFsLCB3aGF0IGNvbG9yIGlzIHRoZSBJbnRlbGxpZ2',
    'otd-SW4gUG9ydGFsLCB3aGF0IGNvbG9yIGlzIHRoZSBNb3JhbGl0eS',
    'otd-SW4gUm9ja2V0IExlYWd1ZSwgeW91IGNhbiBwbGF5IEJhc2tldG',
    'otd-SW4gUmFpbmJvdyA2IFNpZWdlLCB3aGF0IGlzIEVsYSBhbmQgWm',
    'otd-SW4gUmVzaWRlbnQgRXZpbCA0LCB0aGUgQ2hpY2FnbyBUeXBld3',
    'otd-SW4gUnVuZVNjYXBlLCBvbmUgbXVzdCBjb21wbGV0ZSB0aGUgJn',
    'otd-SW4gUnVzdCwgaG93IG1hbnkgVGltZWQgRXhwbG9zaXZlIENoYX',
    'otd-SW4gV29ybGQgb2YgV2FyY3JhZnQgbG9yZSwgIGhvdyBtYW55IH',
    'otd-SW4gV29ybGQgb2YgV2FyY3JhZnQgdGhlIGRlZmF1bHQgVUkgY2',
    'otd-SW4gV29ybGQgb2YgV2FyY3JhZnQmIzAzOTtzIE1pc3RzIG9mIF',
    'otd-SW4gV29ybGQgb2YgV2FyY3JhZnQsIHdoaWNoIHJhaWQgaW5zdG',
    'otd-SW4gV2FyaW9XYXJlOiBTbW9vdGggTW92ZXMsIHdoaWNoIG9uZS',
    'otd-SW4gVG91aG91IDEyOiBVbmRlZmluZWQgRmFudGFzdGljIE9iam',
    'otd-SW4gVG91aG91OiBFbWJvZGltZW50IG9mIFNjYXJsZXQgRGV2aW',
    'otd-SW4gVGhlIEVsZGVyIFNjcm9sbHM6IE9ibGl2aW9uLCB0aGUgaG',
    'otd-SW4gVGhlIEVsZGVyIFNjcm9sbHMgVjogU2t5cmltLCB3aG8gaX',
    'otd-SW4gVGhlIFdpdGNoZXIgMywgdGhlIFpvbHRhbiBDaGl2YXkgR3',
    'otd-SW4gVGVhbSBGb3J0cmVzcyAyLCB0aGUgd2VhcG9uICZxdW90O1',
    'otd-SW4gVGVhbSBGb3J0cmVzcyAyLCBiZWluZyBkaXNndWlzZWQgYX',
    'otd-SW4gVGVsbHRhbGUgR2FtZXMmIzAzOTsgJnF1b3Q7VGhlIFdhbG',
    'otd-SW4gVGVycmFyaWEsIHdoaWNoIG9mIHRoZSBmb2xsb3dpbmcgaX',
    'otd-SW4gVGVycmFyaWEsIHdoaWNoIG9mIHRoZXNlIGl0ZW1zIGlzIE',
    'otd-SW4gVGVycmFyaWEsIHdoYXQgZG9lcyB0aGUgV2FsbCBvZiBGbG',
    'otd-SW4gVGVycmFyaWEsIHlvdSBjYW4gY3JhZnQgdGhlIENlbGwgUG',
    'otd-SW4gVW50aWwgRGF3biwgYm90aCBjaGFyYWN0ZXJzIFNhbSBhbm',
    'otd-SW4gVW5kZXJ0YWxlLCB3aGF0JiMwMzk7cyB0aGUgcHJpemUgZm',
    'otd-SW4gWWFrdXphIDAsIHdoYXQgaXMgdGhlIG9yZGVyIG9mIHRoZS',
    'otd-SW4gY2FyZWVyIG1vZGUgb2YgJnF1b3Q7TmVlZCBmb3IgU3BlZW',
    'otd-T24gd2hpY2ggcGxhbmV0IGRvZXMgdGhlIGdhbWUgRnJlZWRvbS',
    'otd-T24gdGhlIDZ0aCBvZiBKdW5lIDIwMDYsIHdoYXQgd2FzIHRoZS',
    'otd-T25lIG9mIHRoZSBOaW50ZW5kbyBFbnRlcnRhaW5tZW50IFN5c3',
    'otd-TmludGVuZG8gc3RhcnRlZCBvdXQgYXMgYSBwbGF5aW5nIGNhcm',
    'otd-TmludGVuZG8mIzAzOTtzIEx1aWdpIHdhcyBvcmlnaW5hbGx5IG',
    'otd-TS5VLkcuRS5OLiBpcyB0aGUgbmFtZSBmb3Igd2hhdCB0eXBlIG',
    'otd-TW9ydGFsIEtvbWJhdCB3YXMgYWxtb3N0IGJhc2VkIG9uIEplYW',
    'otd-TWlycm9yJiMwMzk7cyBFZGdlIENhdGFseXN0IHRha2VzIHBsYW',
    'otd-U2V2ZXJhbCBjaGFyYWN0ZXJzIGluICZxdW90O1N1cGVyIE1hcm',
    'otd-U3VwZXIgTWFyaW8gQnJvcy4gd2FzIHJlbGVhc2VkIGluIDE5OT',
    'otd-UGlzdG9ucyB3ZXJlIGFkZGVkIHRvIE1pbmVjcmFmdCBpbiBCZX',
    'otd-UGV0ZXIgTW9seW5ldXggd2FzIHRoZSBmb3VuZGVyIG9mIEJ1bG',
    'otd-UHN5Y2gtSG9ycm9yICZxdW90O0V0ZXJuYWwgRGFya25lc3M6IF',
    'otd-Um9sbGVyY29hc3RlciBUeWNvb24gMSBhbmQgMiB3ZXJlIGRldm',
    'otd-UmluY2V3aW5kIGZyb20gdGhlIDE5OTUgRGlzY3dvcmxkIGdhbW',
    'otd-UmViZWNjYSBDaGFtYmVycyBkb2VzIG5vdCBhcHBlYXIgaW4gYW',
    'otd-Unl1amkgU2FrYW1vdG8gaXMgYSBjaGFyYWN0ZXIgZnJvbSBGaW',
    'otd-V2F0Y2hfRG9ncyAyIGlzIGEgcHJlcXVlbC4=',
    'otd-V2h5IHdhcyB0aGUgY2hhcmFjdGVyIFRyZXZvciBQaGlsaXBzIG',
    'otd-V2h5IHdlcmUgb25seSBvbmx5IDMwMCwwMDAgY29waWVzIG9mIF',
    'otd-V2hhdCB2aWRlbyBnYW1lIGdlbnJlIHdlcmUgdGhlIG9yaWdpbm',
    'otd-V2hhdCB2aWRlbyBnYW1lIGNvbXBhbnkgZGV2ZWxvcGVkIHRoZS',
    'otd-V2hhdCB2aWRlbyBnYW1lIGVuZ2luZSBkb2VzIHRoZSB2aWRlb2',
    'otd-V2hhdCB2YXVsdCBpbiB0aGUgdmlkZW8gZ2FtZSAmcXVvdDtGYW',
    'otd-V2hhdCB2ZWhpY2xlIGluIFBVQkcgaGFzIHRoZSBoaWdoZXN0IH',
    'otd-V2hhdCB3YXMgdGhlIE1heGltdW0gTGV2ZWwgaW4gV29ybGQgb2',
    'otd-V2hhdCB3YXMgdGhlIEZJUlNUIFZhbHZlIGdhbWUgdG8gaGF2ZS',
    'otd-V2hhdCB3YXMgdGhlIG1haW4gY3VycmVuY3kgaW4gQ2x1YiBQZW',
    'otd-V2hhdCB3YXMgdGhlIG5hbWUgb2YgdGhlIGNhbmNlbGVkIHByb2',
    'otd-V2hhdCB3YXMgdGhlIG5hbWUgb2YgdGhlIGNhbmNlbGxlZCBzZX',
    'otd-V2hhdCB3YXMgdGhlIG9yaWdpbmFsIG5hbWUgb2YgQ3Jhc2ggQm',
    'otd-V2hhdCB3YXMgdGhlIGZpcnN0IC5oYWNrIGdhbWU/',
    'otd-V2hhdCB3YXMgdGhlIGZpcnN0ICZxdW90O1RlYW0gRm9ydHJlc3',
    'otd-V2hhdCB3YXMgdGhlIGZpcnN0IEdhbWUgcmVsZWFzZWQgdXNpbm',
    'otd-V2hhdCB3YXMgdGhlIGZpcnN0IENhbGwgb2YgRHV0eSBnYW1lIH',
    'otd-V2hhdCB3YXMgdGhlIGZpcnN0IGdhbWUgaW4gdGhlICZxdW90O0',
    'otd-V2hhdCB3YXMgdGhlIGZpcnN0IGludGVyYWN0aXZlIG1vdmllIH',
    'otd-V2hhdCB3YXMgdGhlIGZpcnN0IHdlYXBvbiBwYWNrIGZvciAmcX',
    'otd-V2hhdCB3YXMgdGhlIHJlbGVhc2UgZGF0ZSBvZiAmcXVvdDtHcm',
    'otd-V2hhdCB3YXMgRnJhbmsgV2VzdCYjMDM5O3Mgam9iIGluICZxdW',
    'otd-V2hhdCB3ZXJlIHRoZSBmaXJzdCB0d28gUG9rJmVhY3V0ZTttb2',
    'otd-V2hhdCB3ZXJlIHRoZSBmaXJzdCB0d28gYmxvY2tzIGluICZxdW',
    'otd-V2hhdCB5ZWFyIGRpZCB0aGUgZ2FtZSAmcXVvdDtPdmVyd2F0Y2',
    'otd-V2hhdCB5ZWFyIHdhcyB0aGUgZ2FtZSAmcXVvdDtPdmVyd2F0Y2',
    'otd-V2hhdCB5ZWFyIHdhcyB0aGUgZ2FtZSBEaXNob25vcmVkIHJlbG',
    'otd-V2hhdCB5ZWFyIHdhcyB0aGUgZ2FtZSBUZWFtIEZvcnRyZXNzID',
    'otd-V2hhdCBBbWVyaWNhbiBjaXR5IHdhcyBmZWF0dXJlZCBpbiB0aG',
    'otd-V2hhdCBDb0QgJnF1b3Q7RGVhdGhzdHJlYWsmcXVvdDsgaXMgb2',
    'otd-V2hhdCBDUzpHTyBjYXNlIGNvbnRhaW5zIHRoZSBCdXR0ZXJmbH',
    'otd-V2hhdCBhbmltYWwgaXMgb24gTGluayYjMDM5O3MgcGFqYW1hcy',
    'otd-V2hhdCBhbmltYWwgaXMgZmVhdHVyZWQgaW4gJnF1b3Q7Qmxvb2',
    'otd-V2hhdCBhcmUgdGlueSBUaHdvbXBzIGNhbGxlZCBpbiBTdXBlci',
    'otd-V2hhdCBhcmUgU2FucyBhbmQgUGFweXJ1cyBuYW1lZCBhZnRlci',
    'otd-V2hhdCBibG9jayBpbiBNaW5lY3JhZnQgaGFzIHRoZSBoaWdoZX',
    'otd-V2hhdCBjaGFyYWN0ZXIgaXMgTk9UIGFwYXJ0IG9mIHRoZSBHcm',
    'otd-V2hhdCBjb21wYW55IGRldmVsb3BzIHRoZSBSb2NrIEJhbmQgc2',
    'otd-V2hhdCBjb2xvciBpcyB0aGUgaWNvbmljIGFyY2FkZSBjaGFyYW',
    'otd-V2hhdCBjb3VudHJ5IGlzIFNlYW4gTWF0c3VkYSBmcm9tIGluIF',
    'otd-V2hhdCBkb2VzIElXSEJZRCBzdGFuZCBmb3Igb24gdGhlIHNrdW',
    'otd-V2hhdCBkZXZpY2UgYWxsb3dzIFRyYWNlciB0byBtYW5pcHVsYX',
    'otd-V2hhdCBlbmdpbmUgZGlkIHRoZSBvcmlnaW5hbCAmcXVvdDtIYW',
    'otd-V2hhdCBmb3JtZXIgTU9CQSwgY3JlYXRlZCBieSBXYXlzdG9uZS',
    'otd-V2hhdCBnYW1lIHdhcyB1c2VkIHRvIGFkdmVydGlzZSBTdGVhbT',
    'otd-V2hhdCBob3VzZWhvbGQgaXRlbSBtYWtlIHRoZSBjaGFyYWN0ZX',
    'otd-V2hhdCBpbmdyZWRpZW50cyBhcmUgcmVxdWlyZWQgdG8gbWFrZS',
    'otd-V2hhdCBpcyB0aGUgaGFyZGVzdCBwb3NzaWJsZSBkaWZmaWN1bH',
    'otd-V2hhdCBpcyB0aGUgaXRlbSByZXF1aXJlZCB0byBzdW1tb24gdG',
    'otd-V2hhdCBpcyB0aGUgb25seSBHZW5lcmF0aW9uIElJSSBQb2tlbW',
    'otd-V2hhdCBpcyB0aGUgbG93ZXN0IGFtb3VudCBvZiBtYXggaGVhbH',
    'otd-V2hhdCBpcyB0aGUgbGFzdCBuYW1lIG9mIHRoZSBwcmltYXJ5IG',
    'otd-V2hhdCBpcyB0aGUgbmFtZSBvZiAmcXVvdDtUZWFtIEZvcnRyZX',
    'otd-V2hhdCBpcyB0aGUgbmFtZSBvZiB0aGUgaXNsYW5kIGludHJvZH',
    'otd-V2hhdCBpcyB0aGUgbmFtZSBvZiB0aGUgb25seSBmZW1hbGUgJn',
    'otd-V2hhdCBpcyB0aGUgbmFtZSBvZiB0aGUgbGFyZ2VzdCBwbGFuZX',
    'otd-V2hhdCBpcyB0aGUgbmFtZSBvZiB0aGUgbWFpbiBpc2xhbmQgaW',
    'otd-V2hhdCBpcyB0aGUgbmFtZSBvZiB0aGUgbWFpbiBwcm90YWdvbm',
    'otd-V2hhdCBpcyB0aGUgbmFtZSBvZiB0aGUgcGxheWFibGUgY2hhcm',
    'otd-V2hhdCBpcyB0aGUgbmFtZSBvZiB0aGUgdmlydXMgdGhhdCBpbm',
    'otd-V2hhdCBpcyB0aGUgbmFtZSBvZiB0aGUgNC1hcm1lZCBDaGFvcy',
    'otd-V2hhdCBpcyB0aGUgbmFtZSBvZiB0aGUgOHRoIGluc3RhbGxtZW',
    'otd-V2hhdCBpcyB0aGUgbmFtZSBvZiB0aGUgQ2l0eSBpbiBTYWludH',
    'otd-V2hhdCBpcyB0aGUgbmFtZSBvZiB0aGUgY2hpbGQgcGVyZm9ybW',
    'otd-V2hhdCBpcyB0aGUgbmFtZSBvZiB0aGUgY3JlYXR1cmUgdGhhdC',
    'otd-V2hhdCBpcyB0aGUgbmFtZSBvZiB0aGUgY3VycmVuY3kgaW4gdG',
    'otd-V2hhdCBpcyB0aGUgbmFtZSBvZiB0aGUgYWR2ZW50dXJlciB5b3',
    'otd-V2hhdCBpcyB0aGUgbmFtZSBvZiB0aGUgYWxsaWdhdG9yIGluIF',
    'otd-V2hhdCBpcyB0aGUgbmFtZSBvZiB0aGUgZ2FtZSBkZXZlbG9wZX',
    'otd-V2hhdCBpcyB0aGUgbmFtZSBvZiB0aGUgZmlyc3QgbGV2ZWwgaW',
    'otd-V2hhdCBpcyB0aGUgbmFtZSBvZiB5b3VyIHRlYW0gaW4gU3Rhci',
    'otd-V2hhdCBpcyB0aGUgbmFtZSBvZiBDcmVhbSB0aGUgUmFiYml0Ji',
    'otd-V2hhdCBpcyB0aGUgbmFtZSBvZiBKb2VsJiMwMzk7cyBkYXVnaH',
    'otd-V2hhdCBpcyB0aGUgbmFtZSBvZiBUZWFtIEZvcnRyZXNzIDImIz',
    'otd-V2hhdCBpcyB0aGUgbW9zdCBleHBlbnNpdmUgd2VhcG9uIGluIE',
    'otd-V2hhdCBpcyB0aGUgbWF4aW11bSBIUCBpbiBUZXJyYXJpYT8=',
    'otd-V2hhdCBpcyB0aGUgbWFpbiB0aGVtZSBzb25nIG9mICZxdW90O1',
    'otd-V2hhdCBpcyB0aGUgbWFpbiBjaGFyYWN0ZXIgb2YgTWV0YWwgR2',
    'otd-V2hhdCBpcyB0aGUgcGVyayB0aGF0IHdhcyBpbnRyb2R1Y2VkIG',
    'otd-V2hhdCBpcyB0aGUgcmVhbCBuYW1lIG9mIHRoZSBTY291dCBpbi',
    'otd-V2hhdCBpcyB0aGUgd29ybGQmIzAzOTtzIGZpcnN0IHZpZGVvIG',
    'otd-V2hhdCBpcyB0aGUgNHRoIGJvc3MgaW4gdGhlIDE5OTcgdmlkZW',
    'otd-V2hhdCBpcyB0aGUgQWxpZW4gUmFjZSBpbiB0aGUgZ2FtZSAmcX',
    'otd-V2hhdCBpcyB0aGUgY29kZSBuYW1lIG9mIE1vcmdhbmEgdGhlIG',
    'otd-V2hhdCBpcyB0aGUgYm9zcyByb3VuZCBmZWF0dXJlZCBpbiB0aG',
    'otd-V2hhdCBpcyB0aGUgZnVsbCBuYW1lIG9mIHRoZSBwcm90YWdvbm',
    'otd-V2hhdCBpcyBhIFRldHJpcyBwaWVjZSBjYWxsZWQ/',
    'otd-V2hhdCBpcyBHYWJlIE5ld2VsbCYjMDM5O3MgZmF2b3JpdGUgY2',
    'otd-V2hhdCBtaW5pbXVtIGxldmVsIGluIHRoZSBEZWZlbmNlIHNraW',
    'otd-V2hhdCBtYWlubHkgZmF2b3JlZCByaWZsZSBpcyB1c2VkIGJ5IH',
    'otd-V2hhdCBtYWpvciBldmVudCBjYXVzZWQgdGhlIGV2ZW50cyBvZi',
    'otd-V2hhdCBuYW1lIGRpZCAmcXVvdDtNYXJpbyZxdW90OywgZnJvbS',
    'otd-V2hhdCBVbHRpbWF0ZSBkb2VzIE1ha290byBOYWVnaSwgcHJvdG',
    'otd-V2hhdCBwcm9ncmFtbWluZyBsYW5ndWFnZSB3YXMgdXNlZCB0by',
    'otd-V2hhdCBzb25nIGlzIHBsYXllZCBkdXJpbmcgdGhlIGVuZGluZy',
    'otd-V2hhdCBzeXN0ZW0gd2FzICZxdW90O1RvdWhvdTogSGlnaGx5IF',
    'otd-V2hhdCYjMDM5O3MgdGhlIFRlYW0gRm9ydHJlc3MgMiBTY291dC',
    'otd-V2hhdCYjMDM5O3MgdGhlIGZhbW91cyBsaW5lIFZhYXMgc2F5cy',
    'otd-V2hlbiB3YXMgdGhlIFNlZ2EgR2VuZXNpcyByZWxlYXNlZCBpbi',
    'otd-V2hlbiB3YXMgdGhlIG9yaWdpbmFsIFN0YXIgV2FyczogQmF0dG',
    'otd-V2hlbiB3YXMgdGhlIGdhbWUgJiMwMzk7UG9ydGFsIDImIzAzOT',
    'otd-V2hlbiB3YXMgdGhlIGZpcnN0ICZxdW90O0hhbGYtTGlmZSZxdW',
    'otd-V2hlbiB3YXMgdGhlIHRvcC1kb3duIG9ubGluZSBSUEcgJnF1b3',
    'otd-V2hlbiB3YXMgdGhlIHZpZGVvIGdhbWUgJnF1b3Q7UC5BLk0uRS',
    'otd-V2hlbiB3YXMgJnF1b3Q7R2FycnkmIzAzOTtzIE1vZCZxdW90Oy',
    'otd-V2hlbiB3YXMgJnF1b3Q7THVpZ2kmIzAzOTtzIE1hbnNpb24gMy',
    'otd-V2hlbiB3YXMgQ2hhcHRlciAxIG9mIHRoZSBTb3VyY2UgRW5naW',
    'otd-V2hlbiB3YXMgQ2x1YiBQZW5ndWluIGxhdW5jaGVkPw==',
    'otd-V2hlbiB3YXMgRmluYWwgRmFudGFzeSBYViByZWxlYXNlZD8=',
    'otd-V2hlbiB3YXMgTGVmdCA0IERlYWQgMiByZWxlYXNlZD8=',
    'otd-V2hlbiB3YXMgTWluZWNyYWZ0IGZpcnN0IHJlbGVhc2VkIHRvIH',
    'otd-V2hlbiB3YXMgU3RlYW0gZmlyc3QgcmVsZWFzZWQ/',
    'otd-V2hlbiB3YXMgUG9rZW1vbiBHTyByZWxlYXNlZCBpbiBOb3J0aC',
    'otd-V2hlcmUgZG9lcyAmcXVvdDtUaGUgTGVnZW5kIG9mIFplbGRhOi',
    'otd-V2hpY2ggaXMgbm90IGEgcGxheWFibGUgY2hhcmFjdGVyIGluIH',
    'otd-V2hpY2ggaXMgdGhlIHByb3RhZ29uaXN0IG9mIEJpb3Nob2NrIE',
    'otd-V2hpY2ggb25lcyBvZiB0aGVzZSBNYXJpbyBLYXJ0IGdhbWVzIH',
    'otd-V2hpY2ggb25lIG9mIHRoZSBmaXJzdCBmb3VyIHRpdGxlcyBvZi',
    'otd-V2hpY2ggb25lIG9mIHRoZSBmb2xsb3dpbmcgYWN0b3JzIGRpZC',
    'otd-V2hpY2ggb25lIG9mIHRoZXNlIG5hdGlvbnMgd2FzIGFkZGVkIH',
    'otd-V2hpY2ggb25lIG9mIHRoZXNlIGlzIE5PVCBhbiBvZmZpY2lhbC',
    'otd-V2hpY2ggb25lIG9mIHRoZXNlIGlzIE5PVCBhIGNoYXJhY3Rlci',
    'otd-V2hpY2ggb25lIG9mIHRoZXNlIGNoYXJhY3RlcnMgaXMgTk9UIG',
    'otd-V2hpY2ggb25lIG9mIHRoZXNlIGNoYXJhY3RlcnMgd2FzIGZpcn',
    'otd-V2hpY2ggb25lIG9mIHRoZXNlIHdhcyBub3QgYSBtZW1iZXIgb2',
    'otd-V2hpY2ggb2NjdXBhdGlvbiBkaWQgSm9obiBUYW5uZXIsIHRoZS',
    'otd-V2hpY2ggb2YgdGhlc2UgaXMgbm90IG9uZSBvZiBEcmFjdWxhJi',
    'otd-V2hpY2ggb2YgdGhlc2UgaXMgbm90IGEgcGxheWFibGUgY2hhcm',
    'otd-V2hpY2ggb2YgdGhlc2UgaXMgbm90IGEgd29uZGVyIHdlYXBvbi',
    'otd-V2hpY2ggb2YgdGhlc2UgaXMgbm90IGEgRExDIHZlaGljbGUgaW',
    'otd-V2hpY2ggb2YgdGhlc2UgaXMgbm90IGEgRHJhZ29uIEFnZSBPcm',
    'otd-V2hpY2ggb2YgdGhlc2UgaXMgbm90IGEgRmFsbG91dCBwcm90YW',
    'otd-V2hpY2ggb2YgdGhlc2UgaXMgbm90IGEgY2hhcmFjdGVyIGluIH',
    'otd-V2hpY2ggb2YgdGhlc2UgaXMgbm90IHRoZSBuYW1lIG9mIGEgY2',
    'otd-V2hpY2ggb2YgdGhlc2UgaXMgdGhlIG5hbWUgb2YgYSBjdXQgZW',
    'otd-V2hpY2ggb2YgdGhlc2UgaXMgTk9UIERMQyBmb3IgdGhlIHZpZG',
    'otd-V2hpY2ggb2YgdGhlc2UgaXMgTk9UIGEgbmFtZSBvZiBhIGNpdH',
    'otd-V2hpY2ggb2YgdGhlc2UgaXMgTk9UIGEgbmFtZSBvZiBhIHBsYX',
    'otd-V2hpY2ggb2YgdGhlc2UgaXMgTk9UIGEgcGxheWFibGUgY2hhcm',
    'otd-V2hpY2ggb2YgdGhlc2UgaXMgTk9UIGEgdGVycm9yaXN0IGZhY3',
    'otd-V2hpY2ggb2YgdGhlc2UgaXMgTk9UIGEgSHVtb25nb3VzIEVudG',
    'otd-V2hpY2ggb2YgdGhlc2UgaXMgTk9UIHRoZSBuYW1lIG9mIGEgcm',
    'otd-V2hpY2ggb2YgdGhlc2UgaXMgTk9UIHRoZSBuYW1lIG9mIGEgdG',
    'otd-V2hpY2ggb2YgdGhlc2UgbGV2ZWxzIGRvZXMgTk9UIGFwcGVhci',
    'otd-V2hpY2ggb2YgdGhlc2Ugc29uZ3MgZG9lcyBOT1QgcGxheSBkdX',
    'otd-V2hpY2ggb2YgdGhlc2Ugc3ltYm9scyBjYW4gYmUgc2VlbiBvbi',
    'otd-V2hpY2ggb2YgdGhlc2Ugcm9sZXMgaW4gVG93biBvZiBTYWxlbS',
    'otd-V2hpY2ggb2YgdGhlc2UgdmlkZW8gZ2FtZSBzZXJpZXMgaGF2ZS',
    'otd-V2hpY2ggb2YgdGhlc2UgQ291bnRlci1TdHJpa2UgbWFwcyBpcy',
    'otd-V2hpY2ggb2YgdGhlc2UgR2VuZXJhdGlvbiAxIFBva2Vtb24gZG',
    'otd-V2hpY2ggb2YgdGhlc2UgRm9ydG5pdGUgZW1vdGVzIGRvZXMgTk',
    'otd-V2hpY2ggb2YgdGhlc2UgU3RhcmJvdW5kIHJhY2VzIGhhcyBhIF',
    'otd-V2hpY2ggb2YgdGhlc2UgUG9rJmVhY3V0ZTttb24gY2Fubm90IG',
    'otd-V2hpY2ggb2YgdGhlc2UgY292ZXJ0IGdyb3VwcyBlbXBsb3lzIF',
    'otd-V2hpY2ggb2YgdGhlc2UgY2hhcmFjdGVycyB3YXMgTk9UIHBsYW',
    'otd-V2hpY2ggb2YgdGhlc2UgY2hhcmFjdGVycyB3YXMgYWxtb3N0IG',
    'otd-V2hpY2ggb2YgdGhlc2UgY2hhcmFjdGVycyBpbiAmcXVvdDtVbm',
    'otd-V2hpY2ggb2YgdGhlc2UgY2hhcmFjdGVycyBpcyBOT1QgYSBib3',
    'otd-V2hpY2ggb2YgdGhlc2UgZ2FtZXMgd2FzIE5PVCBhIE5pbnRlbm',
    'otd-V2hpY2ggb2YgdGhlc2UgZ2FtZXMgd2FzIHRoZSBlYXJsaWVzdC',
    'otd-V2hpY2ggb2YgdGhlc2UgZ2FtZXMgdGFrZXMgcGxhY2UgaW4gdG',
    'otd-V2hpY2ggb2YgdGhlc2UgZm9sbG93aW5nIHdlYXBvbiBvciBlcX',
    'otd-V2hpY2ggb2YgdGhlc2UgZmVhdHVyZXMgd2FzIGFkZGVkIGluIH',
    'otd-V2hpY2ggb2YgdGhlIGZvbGxvd2luZyB3YXMgTk9UIGEgcGxheW',
    'otd-V2hpY2ggb2YgdGhlIGZvbGxvd2luZyB3YXMgYSBtYXAgdGhhdC',
    'otd-V2hpY2ggb2YgdGhlIGZvbGxvd2luZyB3ZWFwb25zIGluICZxdW',
    'otd-V2hpY2ggb2YgdGhlIGZvbGxvd2luZyBDb3B5IEFiaWxpdGllcy',
    'otd-V2hpY2ggb2YgdGhlIGZvbGxvd2luZyBFbGl0ZSBGb3VyIG1lbW',
    'otd-V2hpY2ggb2YgdGhlIGZvbGxvd2luZyBjaGFyYWN0ZXJzIHdlcm',
    'otd-V2hpY2ggb2YgdGhlIGZvbGxvd2luZyBjb2xvcnMgZG9lcyB0aG',
    'otd-V2hpY2ggb2YgdGhlIGZvbGxvd2luZyBnYW1lcyB3YXMgTk9UIG',
    'otd-V2hpY2ggb2YgdGhlIGZvbGxvd2luZyBnYW1lcyBoYXMgdGhlIG',
    'otd-V2hpY2ggb2YgdGhlIGZvbGxvd2luZyBnYW1lcyBpbiB0aGUgQW',
    'otd-V2hpY2ggb2YgdGhlIGZvbGxvd2luZyBNYXJpbyBLYXJ0IDggRG',
    'otd-V2hpY2ggb2YgdGhlIGZvbGxvd2luZyBoYXMgSmVubmlmZXIgVG',
    'otd-V2hpY2ggb2YgdGhlIGZvbGxvd2luZyBpcyBOT1QgYSBzdW1tb2',
    'otd-V2hpY2ggb2YgdGhlIGZvbGxvd2luZyBpcyBub3QgYSBjaGFyYW',
    'otd-V2hpY2ggb2YgdGhlIGZvbGxvd2luZyBpcyBub3QgYSBmYWN0aW',
    'otd-V2hpY2ggb2YgdGhlIGZvbGxvd2luZyBpcyBub3QgYSBwcm9zZW',
    'otd-V2hpY2ggb2YgdGhlIGZvbGxvd2luZyBpcyBub3QgYSByZWFsIF',
    'otd-V2hpY2ggb2YgdGhlIGZvbGxvd2luZyBuYW1lcyBpcyB0aGUgJn',
    'otd-V2hpY2ggb2YgdGhlIGZvbGxvd2luZyBUZXJyYW4gdW5pdHMgZn',
    'otd-V2hpY2ggb2YgMiBWYWx2ZSBHYW1lcyBhcmUgc2V0IGluIHRoZS',
    'otd-V2hpY2ggb3BlcmF0aW9uIGluICZxdW90O1RvbSBDbGFuY3kmIz',
    'otd-V2hpY2ggbWVtYmVyIG9mIHRoZSBWZWx2ZXQgUm9vbSBpcyBub3',
    'otd-V2hpY2ggc291bHMgZ2FtZSB3YXMgbm90IGRpcmVjdGVkIGJ5IE',
    'otd-V2hpY2ggc29jY2VyIHBsYXllciBpcyBmZWF0dXJlZCBvbiB0aG',
    'otd-V2hpY2ggc3R1ZGVudCBpbiBZYW5kZXJlIFNpbXVsYXRvciBpcy',
    'otd-V2hpY2ggc3RhZ2Ugd2FzIHBsYW5uZWQgdG8gYmUgYSBwYXJ0IG',
    'otd-V2hpY2ggcG9wIHNpbmdlciB3YXMgYnJvdWdodCBpbiBieSBTRU',
    'otd-V2hpY2ggcHN5Y2hvcGF0aChzKSBpbiBEZWFkIFJpc2luZyAxIG',
    'otd-V2hpY2ggcHV6emxlIGdhbWUgd2FzIGRlc2lnbmVkIGJ5IGEgUn',
    'otd-V2hpY2ggcmFjZSBpbiBHdWlsZCBXYXJzIDIgYmVsaWV2ZXMgaW',
    'otd-V2hpY2ggcmV0cm8gdmlkZW8gZ2FtZSB3YXMgcmVsZWFzZWQgZm',
    'otd-V2hpY2ggd2F0ZXItdHlwZSBQb2smZWFjdXRlO21vbiBzdGFydG',
    'otd-V2hpY2ggd2FzIHRoZSBmaXJzdCAmcXVvdDtDYWxsIE9mIER1dH',
    'otd-V2hpY2ggd2FzIHRoZSBmaXJzdCB2aWRlbyBnYW1lIHRvIGJlIH',
    'otd-V2hpY2ggd2VhcG9uIHRoYXQgd2FzIGN1dCBmcm9tIHRoZSBnYW',
    'otd-V2hpY2ggdG93biB3YXMgU2VhbXVzICZxdW90O1NsZWRnZSZxdW',
    'otd-V2hpY2ggdmlkZW8gZ2FtZSBlYXJuZWQgbXVzaWMgY29tcG9zZX',
    'otd-V2hpY2ggJnF1b3Q7Q2FsbCBPZiBEdXR5OiBab21iaWVzJnF1b3',
    'otd-V2hpY2ggJnF1b3Q7RmFsbG91dDogTmV3IFZlZ2FzJnF1b3Q7IH',
    'otd-V2hpY2ggJnF1b3Q7UGVyay1BLUNvbGEmcXVvdDsgaW4gJnF1b3',
    'otd-V2hpY2ggQ1M6R08gZVNwb3J0cyB0ZWFtIHdvbiB0aGUgbWFqb3',
    'otd-V2hpY2ggQ3J5cHQgb2YgdGhlIE5lY3JvRGFuY2VyICgyMDE1KS',
    'otd-V2hpY2ggQW5pbWFsIENyb3NzaW5nIGdhbWUgd2FzIGZvciB0aG',
    'otd-V2hpY2ggR2FtZSBCb3kgZnJvbSB0aGUgR2FtZSBCb3kgc2VyaW',
    'otd-V2hpY2ggR2FtZSBEZXZlbG9wbWVudCBjb21wYW55IG1hZGUgTm',
    'otd-V2hpY2ggR2VybWFuIGNpdHkgZG9lcyB0aGUgbWFwICZxdW90O0',
    'otd-V2hpY2ggRG90YSAxIGhlcm8gY2hhbmdlZCBnZW5kZXIgd2hlbi',
    'otd-V2hpY2ggRmluYWwgRmFudGFzeSBnYW1lIGNvbnNpc3RlZCBvZi',
    'otd-V2hpY2ggRWxpdGUgRm91ciBtZW1iZXIgZnJvbSB0aGUgZmlyc3',
    'otd-V2hpY2ggS2lyYnkgZ2FtZSBmaXJzdCBpbnRyb2R1Y2VkIENvcH',
    'otd-V2hpY2ggT3ZlcndhdGNoIGNoYXJhY3RlciBzYXlzIHRoZSBsaW',
    'otd-V2hpY2ggTWFyaW8gc3Bpbi1vZmYgZ2FtZSBkaWQgV2FsdWlnaS',
    'otd-V2hpY2ggU29uaWMgdGhlIEhlZGdlaG9nIGdhbWUgaW50cm91ZG',
    'otd-V2hpY2ggU29uaWMgdGhlIEhlZGdlaG9nIGdhbWUgd2FzIG9yaW',
    'otd-V2hpY2ggU3VwZXIgTWFyaW8gdmlkZW8gZ2FtZSB3aGVuIHRoZX',
    'otd-V2hpY2ggUG9rJmVhY3V0ZTttb24gY2FuIGxlYXJuIHRoZSBtb3',
    'otd-V2hpY2ggUG9rZW1vbiBnZW5lcmF0aW9uIGRpZCB0aGUgZmFuLW',
    'otd-V2hpY2ggVG91aG91IGNoYXJhY3RlciBpcyBhIEhlbGwgUmF2ZW',
    'otd-V2hpY2ggY291bnRyeSBpcyBmZWF0dXJlZCBpbiBBY2UgQ29tYm',
    'otd-V2hpY2ggY29tcGFueSBkZXZlbG9wZWQgdGhlIE1NTyBTcGlyYW',
    'otd-V2hpY2ggY29tcGFueSBpcyB0aGUgb25lIHJlc3BvbnNpYmxlIG',
    'otd-V2hpY2ggY29tcGFueSBtYWRlIHRoZSBKYXBhbmVzZSBSUEcgJn',
    'otd-V2hpY2ggY2FyIGlzIE5PVCBmZWF0dXJlZCBpbiAmcXVvdDtOZW',
    'otd-V2hpY2ggY2hhcmFjdGVyIGluIHRoZSAmcXVvdDtBbmltYWwgQ3',
    'otd-V2hpY2ggY2hhcmFjdGVyIGlzIGZyb20gJnF1b3Q7U3BsYXRvb2',
    'otd-V2hpY2ggYWN0b3IgcHJvdmlkZWQgdGhlIHZvaWNlIGZvciB0aG',
    'otd-V2hpY2ggZ2FtaW5nIHNlcmllcyBpbmNsdWRlcyAmcXVvdDtUaG',
    'otd-V2hpY2ggZ2FtZSB3YXMgdGhlIGZpcnN0IHRpbWUgTWFyaW8gd2',
    'otd-V2hpY2ggZ2FtZSBkaWQgJnF1b3Q7U29uaWMgVGhlIEhlZGdlaG',
    'otd-V2hpY2ggZ2FtZSBkaWQgTk9UIGdldCBmaW5hbmNlZCB2aWEgQ3',
    'otd-V2hpY2ggZ2FtZSBpbiB0aGUgJnF1b3Q7RGFyayBTb3VscyZxdW',
    'otd-V2hpY2ggZ2FtZSBpcyBOT1QgcGFydCBvZiB0aGUgU2NpZW5jZS',
    'otd-V2hpY2ggZm9vdGJhbGwgcGxheWVyIGlzIGZlYXR1cmVkIG9uIH',
    'otd-V2hpY2ggZnJhbmNoaXNlIHdhcyBOT1QgZmVhdHVyZWQgaW4gdG',
    'otd-V2hpY2ggZXBpc29kZSBvZiB0aGUgUGhhbnRhc3kgU3RhciBPbm',
    'otd-V2hvIG1hZGUgdGhlIHZpZGVvIGdhbWUsICZxdW90O0JlbmR5IG',
    'otd-V2hvIG1hZGUgR2FycnkmIzAzOTtzIE1vZD8=',
    'otd-V2hvIG91dCBvZiB0aGVzZSBUZWFtIEZvcnRyZXNzIDIgY2hhcm',
    'otd-V2hvIGlzIHRoZSB2aWxsYWluIGNvbXBhbnkgaW4gJnF1b3Q7U3',
    'otd-V2hvIGlzIHRoZSB3cml0ZXIgb2YgdGhlIGdhbWUgJnF1b3Q7SG',
    'otd-V2hvIGlzIHRoZSBjaGFyYWN0ZXIgeW91IHBsYXkgYXMgaW4gWX',
    'otd-V2hvIGlzIHRoZSBjcmVhdG9yIG9mIFRvdWhvdSBwcm9qZWN0Pw',
    'otd-V2hvIGlzIHRoZSBmb3VuZGVyIG9mIFRlYW0gRm9ydHJlc3MgMi',
    'otd-V2hvIGlzIHRoZSBoYWxmLWRlbW9uIGNoYXJhY3RlciBpbiBEaX',
    'otd-V2hvIGlzIHRoZSBsYXN0IGJvc3MgaW4gTmlnaHQgSW4gVGhlIF',
    'otd-V2hvIGlzIHRoZSBsZWFkZXIgb2YgdGhlIEJyb3RoZXJob29kIG',
    'otd-V2hvIGlzIHRoZSBtYWluIGFudGFnb25pc3Qgb2YgT3JpIGFuZC',
    'otd-V2hvIGlzIHRoZSBtYWluIGFudGFnb25pc3Qgb2YgU2lsZW50IE',
    'otd-V2hvIGlzIHRoZSBtYWluIGNoYXJhY3RlciBpbiBNZXRhbCBHZW',
    'otd-V2hvIGlzIHRoZSBtYWluIGNoYXJhY3RlciBpbiBtb3N0IG9mIH',
    'otd-V2hvIGlzIHRoZSBtYWluIGNoYXJhY3RlciBvZiB0aGUgZ2FtZS',
    'otd-V2hvIGlzIHRoZSBtYWluIHByb3RhZ29uaXN0IG9mICZxdW90O0',
    'otd-V2hvIGlzIHRoZSBtYWluIHByb3RhZ29uaXN0IG9mIERlYWQgU3',
    'otd-V2hvIGlzIHRoZSBtYWluIHByb3RhZ29uaXN0IGluIERhbmdhbn',
    'otd-V2hvIGlzIHRoZSBtYWluIHZpbGxhaW4gaW4gQmVuZHkgYW5kIH',
    'otd-V2hvIGlzIHRoZSBtYWluIHZpbGxhaW4gb2YgdGhlIENyYXNoIE',
    'otd-V2hvIGlzIHRoZSBtYWluIHZpbGxhaW4gb2YgS2lyYnkmIzAzOT',
    'otd-V2hvIGlzIHRoZSBwcm90YWdvbmlzdCBpbiB0aGUgZ2FtZSAmcX',
    'otd-V2hvIGlzIHRoZSBwcm90YWdvbmlzdCBpbiBEZWFkIFJpc2luZy',
    'otd-V2hvIGNvbXBvc2VkIHRoZSBzb3VuZHRyYWNrIGZvciB0aGUgZ2',
    'otd-V2hvIGNyZWF0ZWQgdGhlIGluZGllIGFkdmVudHVyZSBnYW1lIC',
    'otd-V2hvIGNyZWF0ZWQgQWdlbnQgNDcgaW4gdGhlIGdhbWUgc2VyaW',
    'otd-V2hvIGRldmVsb3BlZCB0aGUgMjAxNiBmYXJtaW5nIFJQRyAmcX',
    'otd-V2hvIHdhcyB0aGUgbWFpbiBhbnRhZ29uaXN0IG9mIE1heCBQYX',
    'otd-V2hvIHdhcyB0aGUgdm9pY2UgYWN0b3IgZm9yIFNuYWtlIGluIE',
    'otd-V2hvIHdhcyB0aGUgZmlyc3QgamVkaSB0aGF0IFN0YXJraWxsZX',
    'otd-V2hvIHdhcyBUZXRyaXMgY3JlYXRlZCBieT8=',
    'otd-V2hvIHR1cm5zIG91dCB0byBiZSB0aGUgdHJ1ZSB2aWN0b3IgaW',
    'otd-V2hvIHZvaWNlcyB0aGUgaW5mYW1vdXMgQ2l0YWRlbCBTdGF0aW',
    'otd-V2hvIHZvaWNlcyB0aGUgY2hhcmFjdGVyICZxdW90O1Zlcm5vbi',
    'otd-V2hvIHZvaWNlcyBHTGFET1MgaW4gdGhlIFBvcnRhbCBnYW1lcz',
    'otd-V2hvIHZvaWNlcyBNYXggUGF5bmUgaW4gdGhlIDIwMDEgZ2FtZS',
    'otd-V2hvJiMwMzk7cyB0aGUgdm9pY2UgYWN0b3IgZm9yIFRocmFsbC',
    'otd-V2hvJiMwMzk7cyB0aGUgQ2FwdGFpbiBvZiB0aGUgUy5ULkEuUi',
    'otd-V2l0aG91dCBlbmNoYW50bWVudHMsIHdoaWNoIHBpY2theGUgaW',
    'otd-VEYyOiBUaGUgSGVhdnkmIzAzOTtzIHZvaWNlIGFjdG9yLCBHYX',
    'otd-VEYyOiBXaGF0IGNvZGUgZG9lcyBTb2xkaWVyIHB1dCBpbnRvIH',
    'otd-VG9ieSBGb3gmIzAzOTtzICZxdW90O01lZ2Fsb3ZhbmlhJnF1b3',
    'otd-VGhlICYjMDM5OzY0JiMwMzk7IGluIHRoZSBOaW50ZW5kby02NC',
    'otd-VGhlICZsZHF1bztmYWlyeSZyZHF1bzsgdHlwZSBtYWRlIGl0Jn',
    'otd-VGhlIDIwMDUgdmlkZW8gZ2FtZSAmcXVvdDtDYWxsIG9mIER1dH',
    'otd-VGhlIE1hbm4gQ28uIFN0b3JlIGZyb20gVGVhbSBGb3J0cmVzcy',
    'otd-VGhlIEFEQU0gY29sbGVjdGVycyBpbiB0aGUgQmlvc2hvY2sgc2',
    'otd-VGhlIEFjZSBBdHRvcm5leSB0cmlsb2d5IHdhcyBzdXBwb3NlIH',
    'otd-VGhlIEJyYWNrZW4gZnJvbSBMZXRoYWwgQ29tcGFueSBpcyBhbH',
    'otd-VGhlIEludGVybmV0IE1lbWUgJnF1b3Q7QWxsIHlvdXIgYmFzZS',
    'otd-VGhlIEluZGllIEdhbWUgRGV2ZWxvcG1lbnQgU3R1ZGlvIENpbm',
    'otd-VGhlIEtlcmJvbCBTeXN0ZW0gKGZyb20gS2VyYmFsIFNwYWNlIF',
    'otd-VGhlIEtvbmFtaSBDb2RlIGlzIGtub3duIGFzIFVwLCBVcCwgRG',
    'otd-VGhlIEZpYXQgTXVsdGlwbGEgaXMgYSBkcml2YWJsZSBjYXIgaW',
    'otd-VGhlIFBsYXlTdGF0aW9uIHdhcyBvcmlnaW5hbGx5IGEgam9pbn',
    'otd-VGhlIFNuaXBlciYjMDM5O3MgU01HIGluIFRlYW0gRm9ydHJlc3',
    'otd-VGhlIFRvdWhvdSBQcm9qZWN0IHNlcmllcyBvZiBnYW1lcyBpcy',
    'otd-VGhlIG1haW4gcGxheWFibGUgY2hhcmFjdGVyIG9mIHRoZSAyMD',
    'otd-VGhlIG1haW4gYW50YWdvbmlzdCBpbiB0aGUgdmlkZW9nYW1lIF',
    'otd-VGhlIG1vc3QgZ3JhcGhpY2FsbHkgdmlvbGVudCBnYW1lIHRvIH',
    'otd-VGhlIG5hbWVzIG9mIFRvbSBOb29rJiMwMzk7cyBjb3VzaW5zIG',
    'otd-VGhlIG9yaWdpbmFsIFBsYW5ldHNpZGUgd2FzIHJlbGVhc2VkIG',
    'otd-VGhlIG9yaWdpbmFsIG1hc2NvdCBvZiB0aGUgcG9wdWxhciBOaW',
    'otd-VGhlIGdhbWUgJnF1b3Q7SmV0cGFjayBKb3lyaWRlJnF1b3Q7IH',
    'otd-VGhlIGdhbWUgJnF1b3Q7UG9ja2V0IE1vcnR5JnF1b3Q7IGhhcy',
    'otd-VGhlIGdhbWUgR2FycnkmIzAzOTtzIE1vZCBvcmlnaW5hbGx5IH',
    'otd-VGhlIGdhbWVzIENyeSBvZiBGZWFyLCBOYXR1cmFsIFNlbGVjdG',
    'otd-VGhlIGdob3N0cyBpbiAmcXVvdDtQYWMtTWFuJnF1b3Q7IGFuZC',
    'otd-VGhlIGNoYXJhY3RlciB0aGF0IHdvdWxkIGV2ZW50dWFsbHkgYm',
    'otd-VGhlIGNyZWVwZXIgaW4gTWluZWNyYWZ0IHdhcyB0aGUgcmVzdW',
    'otd-VGhlIGRlZmF1bHQgcGxheWVybW9kZWwgb2YgR2FycnkmIzAzOT',
    'otd-VGhlIGVkdXRhaW5tZW50IHZpZGVvIGdhbWUgc2VyaWVzIGNoYX',
    'otd-VGhlIGVuZCBjcmVkaXRzIHNlcXVlbmNlIGluIEdyYW5kIFRoZW',
    'otd-VGhlIGZpcnN0ICZxdW90O01ldGFsIEdlYXImcXVvdDsgZ2FtZS',
    'otd-VGhlIGZpcnN0IE1heGlzIGdhbWUgdG8gZmVhdHVyZSB0aGUgZm',
    'otd-VGhlIGZpcnN0IGdhbWUgaW4gdGhlIFRvdWhvdSBQcm9qZWN0LC',
    'otd-VGhlIGZpcnN0IHZlcnNpb24gb2YgQmxvY2tsYW5kIGNhbWUgb3',
    'otd-VGhlIHByb3RhZ29uaXN0IG9mIERlYWQgUmlzaW5nIDMgaXMgY2',
    'otd-VGhlIHByb3RhZ29uaXN0IGluIHRoZSBnYW1lICZxdW90O0Nhdm',
    'otd-VGhlIHdhbGxzIG9mIHRoZSBHb2xkZW5yb2QgQ2l0eSBHeW0gaW',
    'otd-VGhlIHJldGFpbCBkaXNjIG9mIFRvbnkgSGF3ayYjMDM5O3MgUH',
    'otd-VGhlIHJpZ2h0cyB0byB0aGUgJnF1b3Q7UmF5bWFuJnF1b3Q7IH',
    'otd-VGhlIHN0YXJ0aW5nIHBpc3RvbCBvZiB0aGUgVGVycm9yaXN0IH',
    'otd-VGhlIHNjcmFwcGVkIFNvbmljIHRoZSBIZWRnZWhvZyAyIGxldm',
    'otd-VGhlIHNob3RndW4gYXBwZWFycyBpbiBldmVyeSBudW1iZXJlZC',
    'otd-VGhlIHNvbmcgJnF1b3Q7TWVnYWxvdmFuaWEmcXVvdDsgYnkgVG',
    'otd-VGhlIHZpZGVvIGdhbWUgcHVibGlzaGVycyBrbm93biBhcyAmcX',
    'otd-VmFsdmUgQ29ycG9yYXRpb24gaXMgYW4gQW1lcmljYW4gdmlkZW',
    'otd-VmFsdmUmIzAzOTtzICZxdW90O1BvcnRhbCZxdW90OyBhbmQgJn',
    'otd-JnF1b3Q7TW9uZ29saWEmcXVvdDsgd2FzIGEgcGFydCBvZiB0aG',
    'otd-Q2FsaWZvcm5pYSBpcyBsYXJnZXIgdGhhbiBKYXBhbi4=',
    'otd-QmlraW5pIEF0b2xsIGlzIGluIHdoaWNoIGNvdW50cnk/',
    'otd-QnJvb21lIGlzIGEgdG93biBpbiB3aGljaCBzdGF0ZSBvZiBBdX',
    'otd-QWxsIG9mIHRoZSBmb2xsb3dpbmcgYXJlIGNsYXNzaWZpZWQgYX',
    'otd-QWxsIG9mIHRoZSBmb2xsb3dpbmcgYXJlIHRvd25zL3ZpbGxhZ2',
    'otd-QXJnZW50aW5hJiMwMzk7cyBuYW1lIGNvbWVzIGZyb20gdGhlIG',
    'otd-R290aGVuYnVyZyBpcyB0aGUgY2FwaXRhbCBvZiBTd2VkZW4u',
    'otd-R2licmFsdGFyLCBsb2NhdGVkIGp1c3Qgc291dGggb2YgdGhlIE',
    'otd-R3JlZW5sYW5kIGlzIGEgcGFydCBvZiB3aGljaCBraW5nZG9tPw',
    'otd-R3JlZW5sYW5kIGlzIGFsbW9zdCBhcyBiaWcgYXMgQWZyaWNhLg',
    'otd-S3VhbGEgTHVtcHVyIGlzIHRoZSBjYXBpdGFsIG9mIHdoaWNoIG',
    'otd-SG93IG1hbnkgaW5kZXBlbmRlbnQgY291bnRyaWVzIGFyZSB0aG',
    'otd-SG93IG1hbnkgc3RhcnMgYXJlIGZlYXR1cmVkIG9uIE5ldyBaZW',
    'otd-SG93IG1hbnkgcHJvdmluY2VzIGFyZSBpbiB0aGUgTmV0aGVybG',
    'otd-SG93IG1hbnkgdGltZSB6b25lcyBkb2VzIENoaW5hIGhhdmU/',
    'otd-SG93IG1hbnkgY291bnRpZXMgaW4gdGhlIFJlcHVibGljIG9mIE',
    'otd-SG93IG1hbnkgY291bnRyaWVzIGFyZSBpbnNpZGUgdGhlIFVuaX',
    'otd-SG93IG1hbnkgY291bnRyaWVzIGFyZSBsYXJnZXIgdGhhbiBBdX',
    'otd-SG93IG1hbnkgY291bnRyaWVzIGRvZXMgTWV4aWNvIGJvcmRlcj',
    'otd-SG93IG1hbnkgZmVkZXJhbCBzdGF0ZXMgZG9lcyBHZXJtYW55IG',
    'otd-SG93IHRhbGwgaXMgT25lIFdvcmxkIFRyYWRlIENlbnRlciBpbi',
    'otd-SGFydmFyZCBVbml2ZXJzaXR5IGlzIGxvY2F0ZWQgaW4gd2hpY2',
    'otd-SHVuZ2FyeSBpcyB0aGUgb25seSBjb3VudHJ5IGluIHRoZSB3b3',
    'otd-SmFwYW4gaGFzIGxlZnQtaGFuZCBzaWRlIHRyYWZmaWMu',
    'otd-SW4gd2hpY2ggRW5nbGlzaCBjb3VudHkgaXMgdGhlIGNpdHkgb2',
    'otd-SW4gd2hpY2ggY291bnRyeSBpcyBsb2NhdGVkIHRoZSBtdW5pY2',
    'otd-SW50byB3aGljaCBiYXNpbiBkb2VzIHRoZSBKb3JkYW4gUml2ZX',
    'otd-SXNyYWVsIGlzIDcgaG91cnMgYWhlYWQgb2YgTmV3IFlvcmsu',
    'otd-T24gd2hpY2ggY29udGluZW50IGlzIHRoZSBjb3VudHJ5IG9mIE',
    'otd-T3VhZ2Fkb3Vnb3UgaXMgdGhlIGNhcGl0YWwgb2Ygd2hpY2ggQW',
    'otd-Tm92YSBTY290aWEgaXMgb24gdGhlIGVhc3QgY29hc3Qgb2YgQ2',
    'otd-TW9udHJlYWwgaXMgaW4gd2hpY2ggQ2FuYWRpYW4gcHJvdmluY2',
    'otd-U291dGggQWZyaWNhIGhhcyBtb3JlIHRoYW4gb25lIGNhcGl0YW',
    'otd-U2FudG9yaW5pIGlzIGFuIGlzbGFuZCBiZWxvbmdpbmcgdG8gd2',
    'otd-U2FuIE1hcmlubyBpcyB0aGUgb25seSBjb3VudHJ5IGNvbXBsZX',
    'otd-U2VvdWwgaXMgdGhlIGNhcGl0YWwgb2YgTm9ydGggS29yZWEu',
    'otd-UG9ydHVnYWwmIzAzOTtzIG1vZGVybiB0ZXJyaXRvcnkgd2FzIG',
    'otd-Um91dGUgNjYgaW4gdGhlIFVuaXRlZCBTdGF0ZXMgc3BhbnMgdG',
    'otd-UnVzc2lhIHNoYXJlcyBhIGxhbmQgYm9yZGVyIHdpdGggTm9ydG',
    'otd-V2hhdCB0aW55IHByaW5jaXBhbGl0eSBsaWVzIGJldHdlZW4gU3',
    'otd-V2hhdCB3YXMgdGhlIG9yaWdpbmFsIG5hbWUgb2YgSG8gQ2hpIE',
    'otd-V2hhdCBFdXJvcGVhbiBjb3VudHJ5IGlzIG5vdCBhIHBhcnQgb2',
    'otd-V2hhdCBjb250aW5lbnQgaXMgdGhlIGNvdW50cnkgTGVzb3Roby',
    'otd-V2hhdCBjb3VudHJ5IGhhcyBhIGhvcml6b250YWwgYmljb2xvci',
    'otd-V2hhdCBjb3VudHJ5IGlzIG5vdCBhIHBhcnQgb2YgU2NhbmRpbm',
    'otd-V2hhdCBldmVudCBsZWQgdG8gTGllY2hlbnN0ZWluIGFkZGluZy',
    'otd-V2hhdCBOb3J0aCBBbWVyaWNhbiB0b3VyaXN0IGF0dHJhY3Rpb2',
    'otd-V2hhdCBpc2xhbmQgaW4gdGhlIENhbmFyeSBJc2xhbmRzIHdhcy',
    'otd-V2hhdCBpcyB0aGUgaGlnaGVzdCBtb3VudGFpbiBpbiB0aGUgd2',
    'otd-V2hhdCBpcyB0aGUgb2ZmaWNpYWwgbGFuZ3VhZ2Ugb2YgQmh1dG',
    'otd-V2hhdCBpcyB0aGUgbG9uZ2VzdCByaXZlciBpbiBFdXJvcGU/',
    'otd-V2hhdCBpcyB0aGUgbGFyZ2VzdCBjb3VudHJ5LCBieSBhcmVhLC',
    'otd-V2hhdCBpcyB0aGUgbGFyZ2VzdCBmcmVzaHdhdGVyIGxha2UgYn',
    'otd-V2hhdCBpcyB0aGUgbGFyZ2VzdCBub24tY29udGluZW50YWwgaX',
    'otd-V2hhdCBpcyB0aGUgbm9ydGhlcm5tb3N0IGh1bWFuIHNldHRsZW',
    'otd-V2hhdCBpcyB0aGUgbmFtZSBvZiB0aGUgQ2FuYWRpYW4gbmF0aW',
    'otd-V2hhdCBpcyB0aGUgbmFtZSBvZiB0aGUgY2FwaXRhbCBvZiBUdX',
    'otd-V2hhdCBpcyB0aGUgcmlnaHQgd2F5IHRvIHNwZWxsIHRoZSBjYX',
    'otd-V2hhdCBpcyB0aGUgRmlubmlzaCB3b3JkIGZvciAmcXVvdDtGaW',
    'otd-V2hhdCBpcyB0aGUgUG9saXNoIGNpdHkga25vd24gdG8gR2VybW',
    'otd-V2hhdCBpcyB0aGUgY2FwaXRhbCBvZiBBdXN0cmFsaWE/',
    'otd-V2hhdCBpcyB0aGUgY2FwaXRhbCBvZiBCcmF6aWw/',
    'otd-V2hhdCBpcyB0aGUgY2FwaXRhbCBvZiBCcml0aXNoIENvbHVtYm',
    'otd-V2hhdCBpcyB0aGUgY2FwaXRhbCBvZiBCdXJraW5hIEZhc28/',
    'otd-V2hhdCBpcyB0aGUgY2FwaXRhbCBvZiBCYW5nbGFkZXNoPw==',
    'otd-V2hhdCBpcyB0aGUgY2FwaXRhbCBvZiBDaGlsZT8=',
    'otd-V2hhdCBpcyB0aGUgY2FwaXRhbCBvZiBHcmVlbmxhbmQ/',
    'otd-V2hhdCBpcyB0aGUgY2FwaXRhbCBvZiBJbmRvbmVzaWE/',
    'otd-V2hhdCBpcyB0aGUgY2FwaXRhbCBvZiBKYW1haWNhPw==',
    'otd-V2hhdCBpcyB0aGUgY2FwaXRhbCBvZiBMYW9zPw==',
    'otd-V2hhdCBpcyB0aGUgY2FwaXRhbCBvZiBNYXVyaXRpdXM/',
    'otd-V2hhdCBpcyB0aGUgY2FwaXRhbCBvZiBQZXJ1Pw==',
    'otd-V2hhdCBpcyB0aGUgY2FwaXRhbCBvZiBSb21hbmlhPw==',
    'otd-V2hhdCBpcyB0aGUgY2FwaXRhbCBvZiBTZW5lZ2FsPw==',
    'otd-V2hhdCBpcyBDYW5hZGEmIzAzOTtzIHNtYWxsZXN0IHByb3Zpbm',
    'otd-V2hhdCBpcyBSdXNzaWEmIzAzOTtzIHNlY29uZC1sYXJnZXN0IG',
    'otd-V2hhdCBpcyBzcGVjaWFsIGFib3V0IExha2UgVGl0aWNhY2E/',
    'otd-V2hhdCBtb3VudGFpbiByYW5nZSBsaW5lcyB0aGUgYm9yZGVyIG',
    'otd-V2hlcmUgaXMgdGhlIFZvbGdhIFJpdmVyPw==',
    'otd-V2hlcmUgaXMgdGhlIGFuY2llbnQgY2l0eSBvZiBQZXRyYSBsb2',
    'otd-V2hlcmUgaXMgdGhlIGNpdHkgb2YgSGFhcmxlbSBsb2NhdGVkPw',
    'otd-V2hlcmUgaXMgdGhlIHdvcmxkJiMwMzk7cyBvbGRlc3Qgc3RpbG',
    'otd-V2hlcmUgaXMgVGltYnVrdHUgbG9jYXRlZD8=',
    'otd-V2hlcmUgd291bGQgeW91IGZpbmQgdGhlICZxdW90O1NwYW5pc2',
    'otd-V2hpY2ggaXMgbm90IGEgY291bnRyeSBpbiBBZnJpY2E/',
    'otd-V2hpY2ggaXMgdGhlIGxhcmdlc3Qgb2YgdGhlc2UgNCBpc2xhbm',
    'otd-V2hpY2ggaXMgdGhlIHdvcmxkJiMwMzk7cyBsb25nZXN0IHJpdm',
    'otd-V2hpY2ggaXMgdGhlIHNtYWxsZXN0IGNvdW50cnkgaW4gdGhlIH',
    'otd-V2hpY2ggaXNsYW5kcyBiZWxvdyBoYXZlIGJlZW4gY2xhaW1lZC',
    'otd-V2hpY2ggb25lIG9mIHRoZXNlIGFyY2hpcGVsYWdvcyBhcmUgTk',
    'otd-V2hpY2ggb2YgdGhlc2UgaXMgTk9UIGEgcHJvdmluY2UgaW4gQ2',
    'otd-V2hpY2ggb2YgdGhlc2UgaXMgTk9UIGEgcmVhbCB0ZWN0b25pYy',
    'otd-V2hpY2ggb2YgdGhlc2UgaXMgTk9UIGEgY2l0eSBpbiBJbmRpYT',
    'otd-V2hpY2ggb2YgdGhlc2UgaXMgTk9UIGEgY2l0eSBpbiBTYXVkaS',
    'otd-V2hpY2ggb2YgdGhlc2UgaXMgTk9UIGFuIEF1c3RyYWxpYW4gc3',
    'otd-V2hpY2ggb2YgdGhlc2UgaXNsYW5kIGNvdW50cmllcyBpcyBsb2',
    'otd-V2hpY2ggb2YgdGhlc2UgQW1lcmljYW4gY2l0aWVzIGhhcyBmZX',
    'otd-V2hpY2ggb2YgdGhlc2UgQWZyaWNhbiBjb3VudHJpZXMgbGlzdC',
    'otd-V2hpY2ggb2YgdGhlc2UgQWZyaWNhbiByZWdpb25zIGRvZXMgKm',
    'otd-V2hpY2ggb2YgdGhlc2UgTWVkaXRlcnJhbmlhbiBpc2xhbmRzIG',
    'otd-V2hpY2ggb2YgdGhlc2UgY291bnRyaWVzIGlzICZxdW90O2RvdW',
    'otd-V2hpY2ggb2YgdGhlc2UgY291bnRyaWVzIGlzIE5PVCBhIHBhcn',
    'otd-V2hpY2ggb2YgdGhlc2UgY291bnRyaWVzIGlzIG5vdCB3cml0dG',
    'otd-V2hpY2ggb2YgdGhlc2UgY291bnRyaWVzIGlzIG5vdCBhIFVuaX',
    'otd-V2hpY2ggb2YgdGhlc2UgY291bnRyaWVzIGlzIHRoZSBzbWFsbG',
    'otd-V2hpY2ggb2YgdGhlc2UgY2l0aWVzIGlzIE5PVCBpbiBFbmdsYW',
    'otd-V2hpY2ggb2YgdGhlIGZvbGxvd2luZyBBcmFiIGNvdW50cmllcy',
    'otd-V2hpY2ggb2YgdGhlIGZvbGxvd2luZyBFdXJvcGVhbiBsYW5ndW',
    'otd-V2hpY2ggb2YgdGhlIGZvbGxvd2luZyBjaXRpZXMgaXMgdGhlIG',
    'otd-V2hpY2ggb2YgdGhlIGZvbGxvd2luZyBjb3VudHJpZXMgaGFzIG',
    'otd-V2hpY2ggb2YgdGhlIGZvbGxvd2luZyBjb3VudHJpZXMgaXMgd2',
    'otd-V2hpY2ggb2YgdGhlIGZvbGxvd2luZyBjb3VudHJpZXMgYmFubm',
    'otd-V2hpY2ggb2YgdGhlIGZvbGxvd2luZyBKYXBhbmVzZSBpc2xhbm',
    'otd-V2hpY2ggb2YgdGhlIGZvbGxvd2luZyBmb3JtZXIgWXVnb3NsYX',
    'otd-V2hpY2ggb2YgdGhlIGZvbGxvd2luZyBpcyBOT1QgYSBjYXBpdG',
    'otd-V2hpY2ggb2YgdGhlIGZvbGxvd2luZyBpcyBub3QgYSBtZWdhZG',
    'otd-V2hpY2ggb2YgdGhlIGZvbGxvd2luZyBsYW5kbG9ja2VkIGNvdW',
    'otd-V2hpY2ggb2YgdGhlIGZvbGxvd2luZyBsYW5ndWFnZSBmYW1pbG',
    'otd-V2hpY2ggb2YgdGhlIGZvbGxvd2luZyBsYW5ndWFnZXMgZG9lcy',
    'otd-V2hpY2ggbmF0aW9uIGNsYWltcyBvd25lcnNoaXAgb2YgQW50YX',
    'otd-V2hpY2ggc3RyZXRjaCBvZiB3YXRlciBjb25uZWN0cyB0aGUgQX',
    'otd-V2hpY2ggdHdvIG1vZGVybi1kYXkgY291bnRyaWVzIHVzZWQgdG',
    'otd-V2hpY2ggQ2FuYWRpYW4gcHJvdmluY2UgaGFzIENoYXJsb3R0ZX',
    'otd-V2hpY2ggQm9yb3VnaCBpcyB0aGUgZmFydGhlc3QgaW4gdGhlIG',
    'otd-V2hpY2ggRW5nbGlzaCBjb3VudHkgd2lsbCB5b3UgZmluZCB0aG',
    'otd-V2hpY2ggRXVyb3BlYW4gY2l0eSBoYXMgdGhlIGhpZ2hlc3QgbW',
    'otd-V2hpY2ggUnVzc2lhbiBvYmxhc3QgZm9ybXMgYSBib3JkZXIgd2',
    'otd-V2hpY2ggVVMgc3RhdGUgaXMgYWxzbyBrbm93biBhcyB0aGUgJn',
    'otd-V2hpY2ggY291bnRyeSB3YXMgTk9UIHBhcnQgb2YgdGhlIFNvdm',
    'otd-V2hpY2ggY291bnRyeSBkb2VzIEF1c3RyaWEgbm90IGJvcmRlcj',
    'otd-V2hpY2ggY291bnRyeSBpcyB0aGUgaG9tZSBvZiB0aGUgbGFyZ2',
    'otd-V2hpY2ggY291bnRyeSBpcyBjb21wbGV0ZWx5IGxhbmRsb2NrZW',
    'otd-V2hpY2ggY2l0eSBpcyB0aGUgYmlnZ2VzdCBpbiBDYW5hZGE/',
    'otd-V2l0aCB3aGljaCBjb3VudHJ5IGRvZXMgRnJhbmNlIHNoYXJlIG',
    'otd-VG9yb250byBpcyB0aGUgY2FwaXRhbCBjaXR5IG9mIHRoZSBOb3',
    'otd-VGFzbWFuaWEgaXMgYW4gaXNsYW5kIHN0YXRlIG9mIEF1c3RyYW',
    'otd-VGhlcmUgaXMgYSBjaXR5IGNhbGxlZCBSb21lIGluIGV2ZXJ5IG',
    'otd-VGhlcmUgaXMgYW4gaXNsYW5kIGluIEphcGFuIGNhbGxlZCDFjG',
    'otd-VGhlcmUgZXhpc3RzIGFuIGlzbGFuZCBuYW1lZCAmcXVvdDtKYX',
    'otd-VGhlIEdhbWJpYSBpcyBhIG5hdGlvbiBmb3VuZCBvbiB3aGljaC',
    'otd-VGhlIFB5cmVuZWVzIG1vdW50YWlucyBhcmUgbG9jYXRlZCBvbi',
    'otd-VGhlIFdoaXRlIENsaWZmcyBvZiBEb3ZlciBpcyBsb2NhdGVkIG',
    'otd-VGhlIFJlcHVibGljIG9mIE1hbHRhIGlzIHRoZSBzbWFsbGVzdC',
    'otd-VGhlIFNvbm9yYW4gRGVzZXJ0IGlzIGxvY2F0ZWQgaW4gZWFzdG',
    'otd-VGhlIFNwYWNlIE5lZWRsZSBpcyBsb2NhdGVkIGluIHdoaWNoIG',
    'otd-VGhlIFVTIHN0YXRlIG9mIE5ldyBZb3JrIGhhcyBhYm91dCBhcy',
    'otd-VGhlIGNhcGl0YWwgb2YgQnJhemlsIGlzIFJpbyBkZSBKYW5laX',
    'otd-VGhlIGNvdW50cnkgb2YgQmVsaXplIGJvcmRlcnMgd2hpY2ggY2',
    'otd-VGhlIGRlcmlzaXZlIGFjcm9ueW0gJnF1b3Q7UElJR1MmcXVvdD',
    'otd-VGhlIGxhbmQgbWFzcyBvZiBtb2Rlcm4gZGF5IFR1cmtleSBpcy',
    'otd-VGhlIHByZWZpeCBTaW5vLSAoQXMgaW4gU2luby1BbWVyaWNhbi',
    'otd-VGhlIHN1cmZhY2UgYXJlYSBvZiBSdXNzaWEgaXMgc2xpZ2h0bH',
    'otd-VGhlIHR3byBsYXJnZXN0IGV0aG5pYyBncm91cHMgb2YgQmVsZ2',
    'otd-VGhlIHRoaXJkIGxhcmdlc3QgY291bnRyeSAoYnkgc3F1YXJlIG',
    'otd-VGhlIHRpdGxlIG9mIHRoZSAxOTY5IGZpbG0gJnF1b3Q7S3Jha2',
    'otd-VW50aWwgMTkzOSwgTGFvcyB3YXMgY2FsbGVkIFNpYW0u',
    'otd-JnF1b3Q7VGhlIEJpZyBCYW5nIFRoZW9yeSZxdW90OyB3YXMgZm',
    'otd-Q291bHJvcGhvYmlhIGlzIHRoZSBpcnJhdGlvbmFsIGZlYXIgb2',
    'otd-Q2VsaWFjIERpc2Vhc2UgaXMgYSBkaXNlYXNlIHRoYXQgZWZmZW',
    'otd-Q2VudHJpcGV0YWwgZm9yY2UgaXMgYW4gYXBwYXJlbnQgZm9yY2',
    'otd-QSBwZXJzb24gY2FuIGdldCBzdW5idXJuZWQgb24gYSBjbG91ZH',
    'otd-QW4gQXN0cm9ub21pY2FsIFVuaXQgaXMgdGhlIGRpc3RhbmNlIG',
    'otd-QW4gZXhvdGhlcm1pYyByZWFjdGlvbiBpcyBhIGNoZW1pY2FsIH',
    'otd-QW5hdG9teSBjb25zaWRlcnMgdGhlIGZvcm1zIG9mIG1hY3Jvc2',
    'otd-QWJvdXQgaG93IG9sZCBpcyBFYXJ0aD8=',
    'otd-QWxiZXJ0IEVpbnN0ZWluIHdvbiBhIG5vYmxlIHByaXplIGZvci',
    'otd-QWxsIHRoZSBmb2xsb3dpbmcgbWV0YWwgZWxlbWVudHMgYXJlIG',
    'otd-QWZ0ZXIgd2hpY2ggRGFuaXNoIGNpdHkgaXMgdGhlIDcydGggZW',
    'otd-QXBwcm94aW1hdGVseSBob3cgbG9uZyBpcyBhIHllYXIgb24gVX',
    'otd-QXQgd2hhdCB0ZW1wZXJhdHVyZSBkb2VzIHdhdGVyIGJvaWw/',
    'otd-QXUgb24gdGhlIFBlcmlvZGljIFRhYmxlIHJlZmVycyB0byB3aG',
    'otd-QXV0b3NvbWFsLWRvbWluYW50IENvbXBlbGxpbmcgSGVsaW8tT3',
    'otd-R3JlYXQgV2hpdGVzIHNvbWV0aW1lcyBwZXJmb3JtIHRoZSBidW',
    'otd-RGVpb25pemVkIHdhdGVyIGlzIHdhdGVyIHdpdGggd2hpY2ggb2',
    'otd-Rm9saWMgYWNpZCBpcyB0aGUgc3ludGhldGljIGZvcm0gb2Ygd2',
    'otd-RnJlZGVyaWNrIEJhbnRpbmcgYW5kIEpvaG4gTWFjbGVvZCB3b2',
    'otd-SG93IG1hbnkgaGVhcnRzIGRvZXMgYW4gb2N0b3B1cyBoYXZlPw',
    'otd-SG93IG1hbnkgb2ZmaWNpYWxseSByZWNvZ25pemVkIGR3YXJmIH',
    'otd-SG93IG1hbnkgbGF3cyBvZiB0aGVybW9keW5hbWljcyBhcmUgdG',
    'otd-SG93IG1hbnkgbGVncyBpcyBpdCBiaW9sb2dpY2FsbHkgaW1wb3',
    'otd-SG93IG1hbnkgbW9vbnMgZG9lcyBQbHV0byBoYXZlPw==',
    'otd-SG93IG1hbnkgcHJvdG9ucyBhcmUgaW4gYW4gb3h5Z2VuIGF0b2',
    'otd-SG93IG1hbnkgdGVldGggZG9lcyB0aGUgYXZlcmFnZSBhZHVsdC',
    'otd-SG93IG1hbnkgY2hyb21vc29tZXMgYXJlIGluIHlvdXIgYm9keS',
    'otd-SHVtYW4gY2VsbHMgdHlwaWNhbGx5IGhhdmUgaG93IG1hbnkgY2',
    'otd-SW4gaHVtYW4gYmlvbG9neSwgYSBjaXJjYWRpdW0gcmh5dGhtIH',
    'otd-SW4gdGhlIHBlcmlvZGljIHRhYmxlLCBQb3Rhc3NpdW0mIzAzOT',
    'otd-SW4gQ2hlbWlzdHJ5LCBob3cgbWFueSBpc29tZXJzIGRvZXMgQn',
    'otd-SWduZW91cyByb2NrcyBhcmUgZm9ybWVkIGJ5IGV4Y2Vzc2l2ZS',
    'otd-SXQgd2FzIG9uY2UgYmVsaWV2ZWQgdGhhdCBpbmplY3Rpbmcgc2',
    'otd-T24gd2hpY2ggbWlzc2lvbiBkaWQgdGhlIFNwYWNlIFNodXR0bG',
    'otd-TmF0dXJhbGx5IG9jY3VyaW5nIHVyYW5pdW0gcHJpbWFyaWx5IG',
    'otd-TXlvcGlhIGlzIHRoZSBzY2llbnRpZmljIHRlcm0gZm9yIHdoaW',
    'otd-U3VnYXIgY29udGFpbnMgZmF0Lg==',
    'otd-UG5ldW1vbm91bHRyYW1pY3Jvc2NvcGljc2lsaWNvdm9sY2Fub2',
    'otd-V2F0ZXIgYWx3YXlzIGJvaWxzIGF0IDEwMCZkZWc7QywgMjEyJm',
    'otd-V2hhdCB0ZXJtIGlzIGJlc3QgYXNzb2NpYXRlZCB3aXRoIFNpZ2',
    'otd-V2hhdCBhcmUgaHVtYW4gbmFpbHMgbWFkZSBvZj8=',
    'otd-V2hhdCBhcmUgdGhlIHNtYWxsZXN0IGJsb29kIHZlc3NlbHMgaW',
    'otd-V2hhdCBjYXVzZXMgdGhlIHNvdW5kIG9mIGEgaGVhcnRiZWF0Pw',
    'otd-V2hhdCBjZWxsIG9yZ2FuZWxsZSBpcyBrbm93biBhcyAmcXVvdD',
    'otd-V2hhdCBkaWQgR3JlZ29yeSBNZW5kZWwgdXNlIHRvIHRlc3QgZ2',
    'otd-V2hhdCBkb2VzIENQUiwgdGhlIGVtZXJnZW5jeSBwcm9jZWR1cm',
    'otd-V2hhdCBkb2VzIExBU0VSIHN0YW5kIGZvcj8=',
    'otd-V2hhdCBkb2VzIHRoZSB5ZWxsb3cgZGlhbW9uZCBvbiB0aGUgTk',
    'otd-V2hhdCBkb2VzIHRoZSBzY2llbnRpZmljIG5hbWUgb2YgdGhlIE',
    'otd-V2hhdCBkbyB5b3Ugc3R1ZHkgaWYgeW91IGFyZSBzdHVkeWluZy',
    'otd-V2hhdCBpcyB0aGUgaG90dGVzdCBwbGFuZXQgaW4gdGhlIFNvbG',
    'otd-V2hhdCBpcyB0aGUgaGFsZi1saWZlIG9mIFVyYW5pdW0tMjM1Pw',
    'otd-V2hhdCBpcyB0aGUgb2ZmaWNpYWwgbmFtZSBvZiB0aGUgc3Rhci',
    'otd-V2hhdCBpcyB0aGUgbGFyZ2VzdCBsaXZpbmcgb3JnYW5pc20gY3',
    'otd-V2hhdCBpcyB0aGUgbW9sZWN1bGFyIGZvcm11bGEgb2YgdGhlIG',
    'otd-V2hhdCBpcyB0aGUgbW9sZWN1bGFyIGZvcm11bGEgb2YgR2x1Y2',
    'otd-V2hhdCBpcyB0aGUgbW9sZWN1bGFyIGZvcm11bGEgb2YgT3pvbm',
    'otd-V2hhdCBpcyB0aGUgbW9zdCBwb3RlbnQgdG94aW4ga25vd24/',
    'otd-V2hhdCBpcyB0aGUgbWVkaWNhbCB0ZXJtIGZvciBsb3cgYmxvb2',
    'otd-V2hhdCBpcyB0aGUgc2FtZSBpbiBDZWxzaXVzIGFuZCBGYWhyZW',
    'otd-V2hhdCBpcyB0aGUgc2NpZW50aWZpYyB0ZXJtIGZvciAmIzAzOT',
    'otd-V2hhdCBpcyB0aGUgc2NpZW50aWZpYyBuYW1lIG9mIHRoZSBrbm',
    'otd-V2hhdCBpcyB0aGUgc2NpZW50aWZpYyBuYW1lIGZvciB0aGUgZX',
    'otd-V2hhdCBpcyB0aGUgc3BlZWQgb2YgbGlnaHQgaW4gYSB2YWN1dW',
    'otd-V2hhdCBpcyB0aGUgc3RhbmRhcmQgU0kgdW5pdCBmb3IgdGVtcG',
    'otd-V2hhdCBpcyB0aGUgc3RhbmRhcmQgYXRvbWljIHdlaWdodCBvZi',
    'otd-V2hhdCBpcyB0aGUgdW5pdCBvZiBlbGVjdHJpY2FsIGNhcGFjaX',
    'otd-V2hhdCBpcyB0aGUgdW5pdCBvZiBlbGVjdHJpY2FsIHJlc2lzdG',
    'otd-V2hhdCBpcyB0aGUgTGlubmVhbiBuYW1lIG9mIHRoZSBkb21lc3',
    'otd-V2hhdCBpcyB0aGUgYXRvbWljIG1hc3Mgb2YgQ2FyYm9uPw==',
    'otd-V2hhdCBpcyB0aGUgYXRvbWljIG51bWJlciBvZiB0aGUgZWxlbW',
    'otd-V2hhdCBpcyB0aGUgZWxlbWVudGFsIHN5bWJvbCBmb3IgbWVyY3',
    'otd-V2hhdCBpcyBhbiBleGFtcGxlIG9mIGEgYmFjdGVyaWFsIHBhdG',
    'otd-V2hhdCBpcyBIeXBlcm5hdHJlbWlhPw==',
    'otd-V2hhdCBpcyByYWRpYXRpb24gbWVhc3VyZWQgaW4/',
    'otd-V2hhdCBtaW5lcmFsIGhhcyB0aGUgbG93ZXN0IG51bWJlciBvbi',
    'otd-V2hhdCBtZWRpY2F0aW9uIHdhcyBvbmNlIGNvbW1vbmx5IHVzZW',
    'otd-V2hhdCBudWNsZW90aWRlIHBhaXJzIHdpdGggZ3VhbmluZT8=',
    'otd-V2hhdCBuYW1lIGlzIGdpdmVuIHRvIGFsbCBiYWJ5IG1hcnN1cG',
    'otd-V2hhdCBwb2x5bWVyIGlzIHVzZWQgdG8gbWFrZSBDRHMsIHNhZm',
    'otd-V2hhdCBwYXJ0IG9mIHRoZSBib2R5IHByb2R1Y2VzIGluc3VsaW',
    'otd-V2hhdCBzdGFnZSBvZiBkZXZlbG9wbWVudCBkbyB0aGUgbWFqb3',
    'otd-V2hlcmUgaW4gdGhlIGh1bWFuIGJvZHkgaXMgdGhlIFBpbmVhbC',
    'otd-V2hlcmUgaXMgdGhlIEdsdXRldXMgTWF4aW11cyBtdXNjbGUgbG',
    'otd-V2hlcmUgZGlkIHRoZSBHcmVhdCBTdG9ybSBvZiAxOTg3IG1ha2',
    'otd-V2hlcmUgZGlkIHRoZSBkb2cgYnJlZWQgJnF1b3Q7Q2hpaHVhaH',
    'otd-V2hpY2ggaXMgdGhlIGNoZW1pY2FsIG5hbWUgb2YgSDJPPw==',
    'otd-V2hpY2ggb2YgdGhlc2UgaXMgdXNlZCB0byBzaG93IHRoYXQgRW',
    'otd-V2hpY2ggb2YgdGhlc2UgaXMgTk9UIGEgcGFydCBvZiB0aGUgc3',
    'otd-V2hpY2ggb2YgdGhlc2UgaXMgTk9UIGEgYm9uZSBmb3VuZCBpbi',
    'otd-V2hpY2ggb2YgdGhlc2UgaXMgYSB0eXBlIG9mIHN0cmV0Y2gvZG',
    'otd-V2hpY2ggb2YgdGhlc2UgaXMgYSBzZW1pY29uZHVjdG9yIGFtcG',
    'otd-V2hpY2ggb2YgdGhlc2Ugc3RhcnMgaXMgdGhlIGxhcmdlc3Q/',
    'otd-V2hpY2ggb2YgdGhlc2UgY2hlbWljYWwgY29tcG91bmRzIGlzIE',
    'otd-V2hpY2ggb2YgdGhlc2UgY2hvaWNlcyBpcyBub3Qgb25lIG9mIH',
    'otd-V2hpY2ggb2YgdGhlc2UgYW5pbWFscyBiZWxvbmdzIGluIGNsYX',
    'otd-V2hpY2ggb2YgdGhlc2UgZWxlbWVudHMgb24gdGhlIFBlcmlvZG',
    'otd-V2hpY2ggb2YgdGhlIGZvbGxvd2luZyBibG9vZCB2ZXNzZWxzIG',
    'otd-V2hpY2ggb2YgdGhlIGZvbGxvd2luZyBpcyBhIG1ham9yIG11c2',
    'otd-V2hpY2ggb2YgdGhlIGZvbGxvd2luZyBpcyBjb25zaWRlcmVkIG',
    'otd-V2hpY2ggb2YgdGhlIGZvbGxvd2luZyBwbGFzdGljIGlzIGNvbW',
    'otd-V2hpY2ggbW9vbiBpcyB0aGUgb25seSBzYXRlbGxpdGUgaW4gb3',
    'otd-V2hpY2ggc2NpZW50aWZpYyB1bml0IGlzIG5hbWVkIGFmdGVyIG',
    'otd-V2hpY2ggcG9ydGlvbiBvZiB0aGUgTWFyaWp1YW5hIHBsYW50IH',
    'otd-V2hpY2ggcGFydCBvZiB0aGUgYm9keSBkb2VzIGdsYXVjb21hIG',
    'otd-V2hpY2ggcGxhbmV0IGluIHRoZSBTb2xhciBTeXN0ZW0gaXMgdG',
    'otd-V2hpY2ggdHlwZSBvZiByb2NrIGlzIGNyZWF0ZWQgYnkgaW50ZW',
    'otd-V2hpY2ggY2hlbWljYWwgZWxlbWVudCB3YXMgb3JpZ2luYWxseS',
    'otd-V2hpY2ggY2hlbWljYWwgZWxlbWVudCBoYXMgdGhlIGxvd2VzdC',
    'otd-V2hpY2ggZWxlbWVudCBoYXMgdGhlIGhpZ2hlc3QgbWVsdGluZy',
    'otd-V2hvIG1hZGUgdGhlIGRpc2NvdmVyeSBvZiBYLXJheXM/',
    'otd-VGhlICZxdW90O0d5bXBpZSBTdGluZ2VyJnF1b3Q7IGlzIHRoZS',
    'otd-VGhlICZxdW90O1RpYmlhJnF1b3Q7IGlzIGZvdW5kIGluIHdoaW',
    'otd-VGhlIEF4aW9tIG9mIFByZXZlbnRpdmUgTWVkaWNpbmUgc3RhdG',
    'otd-VGhlIEZyZW5jaCBzY2llbnRpc3RzIExvdWlzIFBhc3RldXIgYW',
    'otd-VGhlIFN1biBjb25zaXN0cyBvZiBtb3N0bHkgd2hpY2ggdHdvIG',
    'otd-VGhlIG1lZGljYWwgdGVybSBmb3IgdGhlIGJlbGx5IGJ1dHRvbi',
    'otd-VGhlIG1lZGljYWwgY29uZGl0aW9uIG9zdGVvcG9yb3NpcyBhZm',
    'otd-VGhlIG1vb25zLCBNaXJhbmRhLCBBcmllbCwgVW1icmllbCwgVG',
    'otd-VGhlIGFzdGVyb2lkIGJlbHQgaXMgbG9jYXRlZCBiZXR3ZWVuIH',
    'otd-VGhlIGJpZ2dlc3QgZGlzdGluY3Rpb24gYmV0d2VlbiBhIGV1a2',
    'otd-VGhlIGNoZW1pY2FsIGVsZW1lbnQgTGl0aGl1bSBpcyBuYW1lZC',
    'otd-VGhlIGVsZW1lbnQgaW52b2x2ZWQgaW4gbWFraW5nIGh1bWFuIG',
    'otd-VGhlIHdvcmQgJnF1b3Q7c2NpZW5jZSZxdW90OyBzdGVtcyBmcm',
    'otd-VGV0c3V5YSBGdWppdGEgd2FzIGEgc2NpZW50aXN0IHRoYXQgZG',
    'otd-VXB3ZWxsaW5nIGluIHRoZSBvY2VhbiBwcm92aWRlcyBjb2xkZX');

INSERT INTO "Question" ("id", "sourceId", "questionEn", "questionFr", "answersEn", "answersFr", "correctIndex", "category", "difficulty", "createdAt") VALUES
    (gen_random_uuid()::text, 'gen-7f7609e54bfb598b', 'Which iconic Nintendo franchise is often compared to The Legend of Zelda in terms of importance?', 'Quelle franchise emblématique de Nintendo est souvent comparée à The Legend of Zelda en termes d''importance ?', '["Pokémon", "Kirby", "Mario", "Metroid"]'::jsonb, '["Pokémon", "Kirby", "Mario", "Metroid"]'::jsonb, 2, 'Video Games', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-b91aa5080a6134cc', 'In The Legend of Zelda, what is the primary goal when exploring a dungeon?', 'Dans The Legend of Zelda, quel est l''objectif principal lors de l''exploration d''un donjon ?', '["Reaching the boss", "Completing the side quests", "Finding all hidden villagers", "Buying a new horse"]'::jsonb, '["Atteindre le boss", "Terminer les quêtes annexes", "Trouver tous les villageois cachés", "Acheter un nouveau cheval"]'::jsonb, 0, 'Video Games', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-977848fc1cd64b4f', 'In The Legend of Zelda, players often receive new items after solving puzzles.', 'Dans The Legend of Zelda, les joueurs reçoivent souvent de nouveaux objets après avoir résolu des énigmes.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Video Games', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-01ef47690a59916b', 'What is the name of Link''s famous mare used for traveling in several Zelda games?', 'Quel est le nom de la célèbre jument de Link utilisée pour voyager dans plusieurs jeux Zelda ?', '["Midona", "Zelda", "Epona", "Navi"]'::jsonb, '["Midona", "Zelda", "Epona", "Navi"]'::jsonb, 2, 'Video Games', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-ac47febedeba08ad', 'The Legend of Zelda: The Adventure of Link is categorized as an action-RPG because it features experience points.', 'The Legend of Zelda: The Adventure of Link est classé comme un action-RPG car il contient des points d''expérience.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Video Games', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-ae92dfc945b669bb', 'In most Zelda games, how many Heart Pieces do you need to collect to get an extra heart container?', 'Dans la plupart des jeux Zelda, combien de fragments de cœurs faut-il rassembler pour obtenir un conteneur de vie supplémentaire ?', '["Six", "Four", "Three", "Five"]'::jsonb, '["Six", "Quatre", "Trois", "Cinq"]'::jsonb, 1, 'Video Games', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-6bdb066e8f51dec4', 'Who is the creator of the Pokémon franchise?', 'Qui est le créateur de la franchise Pokémon ?', '["Satoshi Tajiri", "Masahiro Sakurai", "Hideo Kojima", "Shigeru Miyamoto"]'::jsonb, '["Satoshi Tajiri", "Masahiro Sakurai", "Hideo Kojima", "Shigeru Miyamoto"]'::jsonb, 0, 'Video Games', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-a9101f8930ba4a4d', 'Ash Ketchum is the main character of the Pokémon anime series.', 'Sacha est le personnage principal de la série animée Pokémon.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Video Games', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-6e7279ef39ef63e1', 'What is the name of the electronic device used by trainers to record Pokémon information?', 'Quel est le nom de l''appareil électronique utilisé par les dresseurs pour enregistrer les informations sur les Pokémon ?', '["Poké Ball", "Poké Gear", "Poké Nav", "Pokédex"]'::jsonb, '["Poké Ball", "Poké Gear", "Poké Nav", "Pokédex"]'::jsonb, 3, 'Video Games', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-7ac2edba1b96a5f5', 'In the Pokémon universe, real-world animals exist alongside Pokémon.', 'Dans l''univers Pokémon, les animaux du monde réel cohabitent avec les Pokémon.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 1, 'Video Games', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-dd53472fa6f016d8', 'Which famous Pokémon from Team Rocket is known for being able to speak human language?', 'Quel Pokémon célèbre de la Team Rocket est connu pour être capable de parler le langage humain ?', '["Wobbuffet", "Meowth", "Pikachu", "Psyduck"]'::jsonb, '["Qulbutoké", "Miaouss", "Pikachu", "Psykokwak"]'::jsonb, 1, 'Video Games', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-23fc3621e55961fa', 'Which insect did Satoshi Tajiri raise as a child, inspiring the creation of Pokémon?', 'Quel insecte Satoshi Tajiri élevait-il durant son enfance, ce qui lui aurait inspiré Pokémon ?', '["Butterflies", "Crickets", "Beetles", "Dragonflies"]'::jsonb, '["Des papillons", "Des criquets", "Des scarabées", "Des libellules"]'::jsonb, 1, 'Video Games', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-8c2d48015ffdd937', 'The first Pokémon video games were released on the Game Boy console.', 'Les premiers jeux vidéo Pokémon sont sortis sur la console Game Boy.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Video Games', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-43a97bf631867994', 'In which region does the Dynamax phenomenon occur?', 'Dans quelle région se produit le phénomène Dynamax ?', '["Kanto", "Johto", "Galar", "Alola"]'::jsonb, '["Kanto", "Johto", "Galar", "Alola"]'::jsonb, 2, 'Video Games', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-5e250fe587089738', 'Which Pokémon is responsible for the Dynamax phenomenon in the Galar region?', 'Quel Pokémon est responsable du phénomène Dynamax dans la région de Galar ?', '["Rayquaza", "Eternatus", "Zamazenta", "Zacian"]'::jsonb, '["Rayquaza", "Éthernatos", "Zamazenta", "Zacian"]'::jsonb, 1, 'Video Games', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-1d7e35a0b55a3292', 'Which game series features the famous blue hedgehog Sonic?', 'Quelle série de jeux met en scène le célèbre hérisson bleu Sonic ?', '["Sonic", "Mario", "Tails", "Crash Bandicoot"]'::jsonb, '["Sonic", "Mario", "Tails", "Crash Bandicoot"]'::jsonb, 0, 'Video Games', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-b84b755a567bf8ca', 'Sonic Adventure was a launch title for the Sega Dreamcast console.', 'Sonic Adventure était un jeu de lancement pour la console Sega Dreamcast.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Video Games', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-cd4d0170fbd97efe', 'Which game is often compared to the Mario Party series due to its gameplay concept?', 'Quel jeu est souvent comparé à la série Mario Party pour son concept de jeu ?', '["Sonic Shuffle", "Sonic Drift", "Sonic Pinball Party", "Sonic Labyrinth"]'::jsonb, '["Sonic Shuffle", "Sonic Drift", "Sonic Pinball Party", "Sonic Labyrinth"]'::jsonb, 0, 'Video Games', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-638998fb2cbfae7c', 'Which character made their debut in the game Sonic Triple Trouble?', 'Quel personnage a fait ses débuts dans le jeu Sonic Triple Trouble ?', '["Shadow", "Tails", "Knuckles", "Nack the Weasel"]'::jsonb, '["Shadow", "Tails", "Knuckles", "Nack the Weasel"]'::jsonb, 3, 'Video Games', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-c9c7bb094ded2606', 'Which company created and released the original PlayStation console?', 'Quelle entreprise a conçu et commercialisé la première console PlayStation ?', '["Sony", "Nintendo", "Sega", "Microsoft"]'::jsonb, '["Sony", "Nintendo", "Sega", "Microsoft"]'::jsonb, 0, 'Video Games', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-27f8a2a00d0d62a3', 'The PlayStation project began after a failed partnership with Nintendo.', 'Le projet PlayStation a débuté suite à l''échec d''un partenariat avec Nintendo.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Video Games', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-13ed0950b38e3983', 'During its launch, which console was a direct competitor to the first PlayStation?', 'Lors de son lancement, quelle console était une concurrente directe de la première PlayStation ?', '["GameCube", "Dreamcast", "Sega Saturn", "Xbox"]'::jsonb, '["GameCube", "Dreamcast", "Sega Saturn", "Xbox"]'::jsonb, 2, 'Video Games', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-cd82c9201d660229', 'Who is the engineer often called the ''father of the PlayStation''?', 'Quel ingénieur est souvent surnommé le « père de la PlayStation » ?', '["Norio Ohga", "Ken Kutaragi", "Nobuyuki Idei", "Hiroshi Yamauchi"]'::jsonb, '["Norio Ohga", "Ken Kutaragi", "Nobuyuki Idei", "Hiroshi Yamauchi"]'::jsonb, 1, 'Video Games', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-235112adc11bbf5c', 'The PlayStation was primarily designed to feature 2D pixel-art graphics.', 'La PlayStation a été principalement conçue pour afficher des graphismes en 2D pixel-art.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 1, 'Video Games', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-a2ad9d56dfd80c0a', 'Which of these famous games was released on the original PlayStation?', 'Lequel de ces jeux cultes est sorti sur la première PlayStation ?', '["Super Mario 64", "Sonic the Hedgehog", "Halo", "Crash Bandicoot"]'::jsonb, '["Super Mario 64", "Sonic the Hedgehog", "Halo", "Crash Bandicoot"]'::jsonb, 3, 'Video Games', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-5c1fe10964e380a5', 'Sega was eager to collaborate with Sony to build a CD-ROM based console.', 'Sega était enthousiaste à l''idée de collaborer avec Sony pour construire une console basée sur le CD-ROM.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 1, 'Video Games', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-b95781e98113b631', 'Which game convinced Sony to focus the PlayStation on 3D graphics?', 'Quel jeu a convaincu Sony de miser sur la 3D pour sa PlayStation ?', '["Sonic the Hedgehog", "Super Mario 64", "Virtua Fighter", "Final Fantasy VII"]'::jsonb, '["Sonic the Hedgehog", "Super Mario 64", "Virtua Fighter", "Final Fantasy VII"]'::jsonb, 2, 'Video Games', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-573b58e169316130', 'Sony''s music division played a key role in the early development of the PlayStation.', 'La branche musicale de Sony a joué un rôle clé dans le développement initial de la PlayStation.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Video Games', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-46b07bff0d0ee418', 'After breaking ties with Sony, which company did Nintendo choose to partner with?', 'Après avoir rompu avec Sony, avec quelle entreprise Nintendo a-t-il choisi de s''allier ?', '["Philips", "Sega", "Toshiba", "Panasonic"]'::jsonb, '["Philips", "Sega", "Toshiba", "Panasonic"]'::jsonb, 0, 'Video Games', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-3ba05373249ecc67', 'What is the name of the entity created by Sony to manage its video game business?', 'Quel est le nom de l''entité créée par Sony pour gérer ses activités dans le jeu vidéo ?', '["Sony Digital Entertainment", "Sony Gaming Division", "Sony Interactive Media", "Sony Computer Entertainment"]'::jsonb, '["Sony Digital Entertainment", "Sony Gaming Division", "Sony Interactive Media", "Sony Computer Entertainment"]'::jsonb, 3, 'Video Games', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-d8e51e4d8ba404e6', 'Which iconic Minecraft creature is known for exploding and destroying blocks?', 'Quelle créature emblématique de Minecraft est connue pour exploser et détruire des blocs ?', '["Skeleton", "Creeper", "Enderman", "Zombie"]'::jsonb, '["Squelette", "Creeper", "Enderman", "Zombie"]'::jsonb, 1, 'Video Games', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-992dd075f07680f9', 'Which boss must the player defeat in the End dimension to finish the game?', 'Quel boss le joueur doit-il vaincre dans la dimension de l''End pour finir le jeu ?', '["Wither", "Elder Guardian", "Ender Dragon", "Warden"]'::jsonb, '["Wither", "Ancien Gardien", "Ender Dragon", "Warden"]'::jsonb, 2, 'Video Games', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-8fd87fa114ba5318', 'True or False: Cows and pigs are hostile creatures that attack the player on sight.', 'Vrai ou Faux : Les vaches et les cochons sont des créatures hostiles qui attaquent le joueur dès qu''ils le voient.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 1, 'Video Games', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-0479eb388a5e1e59', 'What substance primarily makes up the Nether dimension?', 'De quelle matière est principalement composée la dimension du Nether ?', '["Sand", "Water", "Ice", "Lava"]'::jsonb, '["Sable", "Eau", "Glace", "Lave"]'::jsonb, 3, 'Video Games', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-406e919f8ef28c41', 'True or False: Aside from Steve and Alex, no other creature in Minecraft is gendered.', 'Vrai ou Faux : Hormis Steve et Alex, aucune autre créature dans Minecraft n''est sexuée.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Video Games', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-76dd3a46244ecb6d', 'Where can the player find the secondary boss known as the Elder Guardian?', 'Où le joueur peut-il trouver le boss secondaire appelé l''Ancien Gardien ?', '["Ancient city", "Ocean temple", "Nether fortress", "Stronghold"]'::jsonb, '["Cité antique", "Temple de l''océan", "Forteresse du Nether", "Stronghold"]'::jsonb, 1, 'Video Games', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-fa69e4511eab9c01', 'Which company is the developer of the game Fortnite?', 'Quelle entreprise est à l''origine du développement de Fortnite ?', '["Electronic Arts", "Activision", "Ubisoft", "Epic Games"]'::jsonb, '["Electronic Arts", "Activision", "Ubisoft", "Epic Games"]'::jsonb, 3, 'Video Games', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-75db6c95a491317d', 'In Fortnite Battle Royale, up to 100 players compete against each other.', 'Dans Fortnite Battle Royale, jusqu''à 100 joueurs s''affrontent simultanément.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Video Games', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-3ebe08e8285fdba4', 'Which of these is NOT a basic resource you can collect in Fortnite?', 'Lequel de ces éléments n''est PAS une ressource de base que l''on peut collecter dans Fortnite ?', '["Wood", "Brick", "Plastic", "Metal"]'::jsonb, '["Bois", "Brique", "Plastique", "Métal"]'::jsonb, 2, 'Video Games', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-381c8f850afa3d86', 'The ''Save the World'' mode is a player-versus-player game.', 'Le mode « Sauver le monde » est un jeu de type joueur contre joueur.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 1, 'Video Games', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-8df65c17bff3666f', 'Which game is Fortnite Festival similar to?', 'À quel jeu le mode Fortnite Festival ressemble-t-il ?', '["Rocket League", "Guitar Hero", "Minecraft", "Tetris"]'::jsonb, '["Rocket League", "Guitar Hero", "Minecraft", "Tetris"]'::jsonb, 1, 'Video Games', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-23d1861a77719338', 'Which game genre combination inspired the creation of Fortnite?', 'Quel mélange de genres a inspiré la création de Fortnite ?', '["Sports and role-playing", "Horror and exploration", "Construction and shooting", "Racing and strategy"]'::jsonb, '["Sport et jeu de rôle", "Horreur et exploration", "Construction et tir", "Course et stratégie"]'::jsonb, 2, 'Video Games', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-55e526f01561665a', 'Which game inspired the sandbox mode of Fortnite Creative?', 'Quel jeu a inspiré le mode bac à sable de Fortnite Créatif ?', '["Lego Worlds", "Minecraft", "Roblox", "Terraria"]'::jsonb, '["Lego Worlds", "Minecraft", "Roblox", "Terraria"]'::jsonb, 1, 'Video Games', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-e799ea9b8a829a32', 'Which game provided the vehicles for the Fortnite Rocket Racing mode?', 'Quel jeu a fourni les voitures pour le mode Rocket Racing de Fortnite ?', '["Mario Kart", "Rocket League", "Need for Speed", "Gran Turismo"]'::jsonb, '["Mario Kart", "Rocket League", "Need for Speed", "Gran Turismo"]'::jsonb, 1, 'Video Games', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-fd0bae255ed3c48e', 'The original Fortnite map remains playable today.', 'La carte originale de Fortnite est toujours jouable aujourd''hui.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 1, 'Video Games', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-006df90be06a286c', 'Fortnite Ballistic is a five-versus-five tactical shooter.', 'Fortnite Ballistic est un jeu de tir tactique en cinq contre cinq.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Video Games', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-b603db75aacb1720', 'What does the term ''Grand Theft Auto'' literally mean?', 'Que signifie littéralement l''expression ''Grand Theft Auto'' ?', '["Police chase", "Armed robbery", "Car theft", "Street racing"]'::jsonb, '["Course-poursuite", "Braquage à main armée", "Vol de voiture", "Course de rue"]'::jsonb, 2, 'Video Games', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-7406a22a97c795a6', 'Which country is the studio Rockstar North from?', 'De quel pays est originaire le studio Rockstar North ?', '["United States", "England", "Scotland", "Canada"]'::jsonb, '["États-Unis", "Angleterre", "Écosse", "Canada"]'::jsonb, 2, 'Video Games', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-131e144bbebd76e8', 'Which of these famous artists has lent their voice to a Grand Theft Auto game?', 'Lequel de ces artistes célèbres a prêté sa voix à un jeu Grand Theft Auto ?', '["Elton John", "Madonna", "David Bowie", "Phil Collins"]'::jsonb, '["Elton John", "Madonna", "David Bowie", "Phil Collins"]'::jsonb, 3, 'Video Games', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-ae7257ae05395f86', 'The Grand Theft Auto series is known for its open-world gameplay.', 'La série Grand Theft Auto est connue pour son système de jeu en monde ouvert.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Video Games', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-c2289ad9a485d29c', 'The cities featured in the Grand Theft Auto series are all real-world locations.', 'Les villes présentes dans la série Grand Theft Auto sont toutes des lieux réels.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 1, 'Video Games', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-b885427b86331688', 'It is impossible to play Grand Theft Auto V in first-person view.', 'Il est impossible de jouer à Grand Theft Auto V en vue à la première personne.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 1, 'Video Games', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-27d9e107c332e8de', 'Which city, inspired by New York, is the most recurring location in the Grand Theft Auto series?', 'Quelle ville, inspirée de New York, est la plus récurrente dans la saga Grand Theft Auto ?', '["Liberty City", "Vice City", "San Andreas", "Los Santos"]'::jsonb, '["Liberty City", "Vice City", "San Andreas", "Los Santos"]'::jsonb, 0, 'Video Games', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-9d74c2cf69296880', 'What represents the level of criminality and police pursuit intensity in Grand Theft Auto games?', 'Que représentent les « étoiles » affichées à l''écran dans les jeux Grand Theft Auto ?', '["The amount of money earned", "The number of missions completed", "The level of criminality", "The health of the hero"]'::jsonb, '["La quantité d''argent gagnée", "Le nombre de missions terminées", "Le niveau de criminalité", "La santé du héros"]'::jsonb, 2, 'Video Games', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-8117a3eb4893b897', 'The Grand Theft Auto saga is currently divided into three distinct universes.', 'La saga Grand Theft Auto est divisée en trois univers distincts.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Video Games', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-54ef73a0efc76ad8', 'Grand Theft Auto Online is simply the multiplayer mode of Grand Theft Auto V.', 'Grand Theft Auto Online est simplement le mode multijoueur de Grand Theft Auto V.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 1, 'Video Games', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-c3670ebba87b5e19', 'Which numbered episode of the Grand Theft Auto series is the only one not to be part of a trilogy or have a direct sequel?', 'Quel épisode chiffré de la saga Grand Theft Auto est le seul à ne pas faire partie d''une trilogie et à ne pas avoir de suite directe ?', '["Grand Theft Auto V", "Grand Theft Auto 2", "Grand Theft Auto IV", "Grand Theft Auto III"]'::jsonb, '["Grand Theft Auto V", "Grand Theft Auto 2", "Grand Theft Auto IV", "Grand Theft Auto III"]'::jsonb, 1, 'Video Games', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-6e2992680d2eb735', 'Which real-world city served as the inspiration for Los Santos in the Grand Theft Auto series?', 'Quelle ville réelle a servi d''inspiration pour créer Los Santos dans la saga Grand Theft Auto ?', '["New Jersey", "Miami", "Los Angeles", "New York"]'::jsonb, '["New Jersey", "Miami", "Los Angeles", "New York"]'::jsonb, 2, 'Video Games', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-556b47227c597a3f', 'Which country is the creator of Tetris from?', 'De quel pays est originaire le créateur de Tetris ?', '["Japan", "Germany", "Soviet Union", "United States"]'::jsonb, '["Japon", "Allemagne", "Union soviétique", "États-Unis"]'::jsonb, 2, 'Video Games', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-c82fca4fe8fc0d1b', 'What are the shapes that fall in the game Tetris called?', 'Comment appelle-t-on les pièces qui tombent dans Tetris ?', '["Tetrominos", "Blocks", "Bricks", "Squares"]'::jsonb, '["Tétrominos", "Blocs", "Briques", "Carrés"]'::jsonb, 0, 'Video Games', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-93a5858c12361a4b', 'You can win a game of Tetris by clearing enough lines.', 'Il est possible de gagner une partie de Tetris en réussissant à effacer suffisamment de lignes.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 1, 'Video Games', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-4ecc351df2517268', 'What do you call the move where you clear 4 lines at once?', 'Comment appelle-t-on l''action de supprimer 4 lignes d''un coup ?', '["A Tetris", "A Line", "A Perfect", "A Combo"]'::jsonb, '["Un Tetris", "Une ligne", "Un parfait", "Un combo"]'::jsonb, 0, 'Video Games', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-32fb051a5f5b347c', 'Tetris is often described as easy to learn but hard to master.', 'Tetris est souvent décrit comme un jeu facile à apprendre mais difficile à maîtriser.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Video Games', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-97454c163c6319da', 'What happens in the original game when you reach 100,000 points?', 'Que se passe-t-il dans la version originale du jeu quand on atteint 100 000 points ?', '["The screen turns white", "The game speeds up", "The music stops", "A rocket takes off"]'::jsonb, '["L''écran devient blanc", "Le jeu accélère", "La musique s''arrête", "Une fusée décolle"]'::jsonb, 3, 'Video Games', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-6c9b6524f51c07fd', 'From which Greek prefix does the name Tetris originate?', 'De quel préfixe grec provient le nom Tetris ?', '["Tetra", "Hexa", "Trio", "Penta"]'::jsonb, '["Tetra", "Hexa", "Trio", "Penta"]'::jsonb, 0, 'Video Games', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-bc58f94580e9d9a0', 'Which Tetrimino is needed to perform a move called a ''Tetris''?', 'Quel tétrimino permet de réaliser le coup nommé « Tetris » ?', '["The T-piece", "The I-piece", "The S-piece", "The O-piece"]'::jsonb, '["Le tétrimino T", "Le tétrimino I", "Le tétrimino S", "Le tétrimino O"]'::jsonb, 1, 'Video Games', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-51c98a76e03ffb50', 'In Tetris, you can rotate the blocks while they are falling.', 'Dans Tetris, il est possible de faire tourner les blocs pendant leur chute.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Video Games', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-f2d52c3c14b9476d', 'On which console did the multiplayer mode for Tetris first appear?', 'Sur quelle console le mode multijoueur est-il apparu pour la première fois dans Tetris ?', '["NES", "Sega Genesis", "Game Boy", "Super Nintendo"]'::jsonb, '["NES", "Mega Drive", "Game Boy", "Super Nintendo"]'::jsonb, 2, 'Video Games', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-782b4042365b844a', 'In multiplayer, how many lines of ''garbage'' are sent to your opponent when you complete a Tetris?', 'En mode multijoueur, combien de lignes de malus envoie-t-on à son adversaire en réussissant un Tetris ?', '["4", "2", "3", "1"]'::jsonb, '["4", "2", "3", "1"]'::jsonb, 0, 'Video Games', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-a64e8bd11d5907d4', 'Who created the famous arcade game Pac-Man?', 'Qui a créé le célèbre jeu d''arcade Pac-Man ?', '["Satoshi Tajiri", "Hideo Kojima", "Tōru Iwatani", "Shigeru Miyamoto"]'::jsonb, '["Satoshi Tajiri", "Hideo Kojima", "Tōru Iwatani", "Shigeru Miyamoto"]'::jsonb, 2, 'Video Games', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-17db84b0b102e675', 'The name ''Pac-Man'' comes from a Japanese onomatopoeia describing the sound of eating.', 'Le nom « Pac-Man » vient d''une onomatopée japonaise décrivant le bruit que l''on fait en mangeant.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Video Games', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-afeb0ac1c4d7b7e0', 'What color is the ghost nicknamed Blinky in the game Pac-Man?', 'Quelle est la couleur du fantôme surnommé Blinky dans le jeu Pac-Man ?', '["Blue", "Red", "Orange", "Pink"]'::jsonb, '["Bleu", "Rouge", "Orange", "Rose"]'::jsonb, 1, 'Video Games', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-9a51be1e19651250', 'The original name of Pac-Man was changed because it could be easily vandalized to sound offensive.', 'Le nom original de Pac-Man a été modifié car il pouvait être facilement vandalisé pour devenir insultant.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Video Games', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-01bcf454626e952e', 'Which ghost in Pac-Man is known for being temperamental and sometimes moving in the opposite direction of the player?', 'Quel fantôme dans Pac-Man est connu pour être capricieux et partir parfois dans la direction opposée au joueur ?', '["Inky", "Clyde", "Pinky", "Blinky"]'::jsonb, '["Inky", "Clyde", "Pinky", "Blinky"]'::jsonb, 0, 'Video Games', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-84274209e318e71d', 'Which game was released in 1981 as the second installment in the Pac-Man series?', 'Quel jeu est sorti en 1981 en tant que second épisode de la série Pac-Man ?', '["Ms. Pac-Man", "Pac-Mania", "Jr. Pac-Man", "Pac-Man 256"]'::jsonb, '["Ms. Pac-Man", "Pac-Mania", "Jr. Pac-Man", "Pac-Man 256"]'::jsonb, 0, 'Video Games', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-7c9bea98f60f049e', 'In the original Pac-Man, the movement of the ghosts is completely random.', 'Dans le jeu Pac-Man original, le déplacement des fantômes est totalement aléatoire.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 1, 'Video Games', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-fa906e77c8e2e59f', 'Which number represents the final level of the original Pac-Man game, where a famous bug occurs?', 'Quel numéro représente le niveau final du jeu Pac-Man original, où survient un bug célèbre ?', '["1024", "512", "128", "256"]'::jsonb, '["1024", "512", "128", "256"]'::jsonb, 3, 'Video Games', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-c10f010c230f8e61', 'Google once turned its map service into a playable Pac-Man game for an April Fools'' Day.', 'Google a déjà transformé son service de cartes en un jeu Pac-Man jouable pour un poisson d''avril.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Video Games', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-078c4f13c76037c9', 'Before Pac-Man''s success, which racing game did marketing experts incorrectly predict would be the biggest hit?', 'Avant le succès de Pac-Man, quel jeu de course les responsables marketing pensaient-ils à tort être le plus prometteur ?', '["Out Run", "Pole Position", "Daytona USA", "Rally-X"]'::jsonb, '["Out Run", "Pole Position", "Daytona USA", "Rally-X"]'::jsonb, 3, 'Video Games', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-136e97b2b0133444', 'Pac-Man was one of the first video games to be famous for what commercial practice?', 'Pac-Man fut l''un des premiers jeux vidéo à être célèbre pour quelle pratique commerciale ?', '["Early access", "Merchandising", "In-game advertising", "Subscription models"]'::jsonb, '["Accès anticipé", "Produits dérivés", "Publicité intégrée", "Abonnements"]'::jsonb, 1, 'Video Games', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-1664de10433f22dc', 'What genre of video game is the famous series Street Fighter?', 'Quel est le genre de la célèbre série de jeux vidéo Street Fighter ?', '["Fighting game", "First-person shooter", "Racing game", "Platformer"]'::jsonb, '["Jeu de combat", "Jeu de tir à la première personne", "Jeu de course", "Jeu de plateforme"]'::jsonb, 0, 'Video Games', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-2b806cff227d9804', 'The term ''Streetfighter'' is exclusively used to describe video games.', 'Le terme ''Streetfighter'' est utilisé exclusivement pour désigner des jeux vidéo.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 1, 'Video Games', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-9535a554c32a71e7', 'Which actor starred in the 1974 martial arts film ''The Street Fighter''?', 'Quel acteur est la vedette du film d''arts martiaux ''The Street Fighter'' sorti en 1974 ?', '["Jackie Chan", "Bruce Lee", "Sonny Chiba", "Jet Li"]'::jsonb, '["Jackie Chan", "Bruce Lee", "Sonny Chiba", "Jet Li"]'::jsonb, 2, 'Video Games', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-5ebc1cc6b63fe1e7', 'The name Street Fighter has also been used for a comic book.', 'Le nom Street Fighter a également été utilisé pour une bande dessinée.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Video Games', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-8a56d45f5d0fc30b', 'Which specific character from the game inspired the title of the 2009 film ''Legend of...''', 'Quel personnage du jeu a inspiré le titre du film ''Legend of...'' sorti en 2009 ?', '["Guile", "Chun-Li", "Ryu", "Ken"]'::jsonb, '["Guile", "Chun-Li", "Ryu", "Ken"]'::jsonb, 1, 'Video Games', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-7aa34418c248ce0e', 'Which company publishes the popular life simulation game series The Sims?', 'Quelle entreprise édite la célèbre série de jeux de simulation de vie Les Sims ?', '["Nintendo", "Electronic Arts", "Ubisoft", "Activision"]'::jsonb, '["Nintendo", "Electronic Arts", "Ubisoft", "Activision"]'::jsonb, 1, 'Video Games', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-b3ac031df9cc4576', 'What is the name of the currency used by characters in The Sims?', 'Comment s''appelle la monnaie utilisée par les personnages dans Les Sims ?', '["Simdollars", "Simcredits", "Simoleons", "Simcoins"]'::jsonb, '["Simdollars", "Simcrédits", "Simflouzes", "Simpièces"]'::jsonb, 2, 'Video Games', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-e4167aeec29ee802', 'The Sims is a game where you must reach a specific objective to win.', 'Les Sims est un jeu où il faut atteindre un objectif précis pour gagner.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 1, 'Video Games', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-b9ae0311a2df17af', 'In what form can deceased Sims reappear in the game?', 'Sous quelle forme les Sims décédés peuvent-ils réapparaître dans le jeu ?', '["Statues", "Zombies", "Ghosts", "Shadows"]'::jsonb, '["Statues", "Zombies", "Fantômes", "Ombres"]'::jsonb, 2, 'Video Games', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-90eac131e412f704', 'The Sims inhabitants are the residents of which other famous city-building game series?', 'Les Sims sont les habitants de quelle autre célèbre série de jeux de construction de ville ?', '["SimCity", "SimWorld", "SimTown", "SimLife"]'::jsonb, '["SimCity", "SimWorld", "SimTown", "SimLife"]'::jsonb, 0, 'Video Games', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-80fbb55926776e63', 'In the game The Sims, which of these needs is typically satisfied by using a shower?', 'Dans le jeu Les Sims, quel besoin est généralement satisfait en utilisant une douche ?', '["Hygiene", "Energy", "Hunger", "Social"]'::jsonb, '["Hygiène", "Énergie", "Appétit", "Vie sociale"]'::jsonb, 0, 'Video Games', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-ea265db666f0eb1b', 'In The Sims 3, a Simbot will thrive if it takes a shower.', 'Dans Les Sims 3, un Simbot est en pleine forme s''il prend une douche.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 1, 'Video Games', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-4618bb7441610eea', 'Which of these is one of the three specific needs of a Végésim?', 'Lequel de ces besoins est l''un des trois besoins spécifiques d''un Végésim ?', '["Entertainment", "Sunlight", "Comfort", "Hygiene"]'::jsonb, '["Distractions", "Lumière du soleil", "Confort", "Hygiène"]'::jsonb, 1, 'Video Games', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-7d5809b93abf9fe5', 'In The Sims, children are required to go to school instead of going to work.', 'Dans Les Sims, les enfants doivent aller à l''école au lieu d''aller travailler.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Video Games', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-d73e92567847f4b8', 'Generally speaking, what happens when you buy more expensive objects for your Sims?', 'En général, que se passe-t-il lorsque vous achetez des objets plus chers pour vos Sims ?', '["They make the Sim sad", "They break more often", "They satisfy needs more efficiently", "They work slower"]'::jsonb, '["Ils rendent le Sim triste", "Ils se cassent plus souvent", "Ils satisfont les besoins plus efficacement", "Ils fonctionnent moins vite"]'::jsonb, 2, 'Video Games', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-4d51551173565aed', 'What is the name of the machine used in Assassin''s Creed to explore ancestral memories?', 'Comment s''appelle la machine utilisée dans Assassin''s Creed pour explorer la mémoire des ancêtres ?', '["Animus", "Abstergo", "Helix", "Nexus"]'::jsonb, '["Animus", "Abstergo", "Helix", "Nexus"]'::jsonb, 0, 'Video Games', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-2913c3c044662510', 'Which novel inspired the creation of the Assassin''s Creed series?', 'Quel roman a inspiré la création de la série Assassin''s Creed ?', '["The Crusades", "Alamut", "Sengoku Tales", "Templar Secrets"]'::jsonb, '["Les Croisades", "Alamut", "Contes du Sengoku", "Secrets Templiers"]'::jsonb, 1, 'Video Games', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-6e538c1b15ea9ee6', 'In the Assassin''s Creed series, the Assassins are in constant conflict with the Templars.', 'Dans la série Assassin''s Creed, les Assassins sont en conflit constant avec les Templiers.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Video Games', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-b4e56f611a4eb87e', 'Desmond Miles is the protagonist of the very first Assassin''s Creed game set in the 16th century.', 'Desmond Miles est le protagoniste du tout premier jeu Assassin''s Creed se déroulant au XVIe siècle.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 1, 'Video Games', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-5d38eaceff27ec25', 'Who is the Master Assassin featured in the first Assassin''s Creed game?', 'Qui est le maître Assassin présent dans le premier jeu Assassin''s Creed ?', '["Edward Kenway", "Ezio Auditore", "Altaïr Ibn La-Ahad", "Connor Kenway"]'::jsonb, '["Edward Kenway", "Ezio Auditore", "Altaïr Ibn La-Ahad", "Connor Kenway"]'::jsonb, 2, 'Video Games', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-a58c71c7984e834c', 'Which game genre best describes Assassin''s Creed?', 'Quel genre de jeu décrit le mieux Assassin''s Creed ?', '["Open world action-adventure", "Sports simulation", "First-person shooter", "Turn-based strategy"]'::jsonb, '["Action-aventure en monde ouvert", "Simulation de sport", "Jeu de tir à la première personne", "Stratégie au tour par tour"]'::jsonb, 0, 'Video Games', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-7de75f1f906b71a2', 'What is the signature weapon of the Assassins?', 'Quelle est l''arme emblématique des Assassins ?', '["Hidden pistol", "Hidden dagger", "Hidden sword", "Hidden blade"]'::jsonb, '["Pistolet secret", "Dague secrète", "Épée secrète", "Lame secrète"]'::jsonb, 3, 'Video Games', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-cac15e49d40ec499', 'Parkour is a core gameplay element of the Assassin''s Creed series.', 'Le parkour est un élément central du gameplay de la série Assassin''s Creed.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Video Games', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-e4c3203ec983386b', 'Which game series introduced the famous Raving Rabbids?', 'Dans quelle série de jeux les Lapins Crétins ont-ils fait leur première apparition ?', '["Splinter Cell", "Prince of Persia", "Assassin''s Creed", "Rayman"]'::jsonb, '["Splinter Cell", "Prince of Persia", "Assassin''s Creed", "Rayman"]'::jsonb, 3, 'Video Games', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-88c5644acaf32a07', 'Which Ubisoft franchise is described as the company''s biggest series?', 'Quelle franchise est devenue la plus importante série de jeux d''Ubisoft ?', '["Splinter Cell", "Just Dance", "Prince of Persia", "Assassin''s Creed"]'::jsonb, '["Splinter Cell", "Just Dance", "Prince of Persia", "Assassin''s Creed"]'::jsonb, 3, 'Video Games', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-300bc83238e1f6f3', 'Just Dance is a rhythm game based on dancing.', 'Just Dance est un jeu de rythme basé sur la danse.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Video Games', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-bfbdca05467fe839', 'Ubisoft has its own film and television production company.', 'Ubisoft possède sa propre société de production de films et de séries.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Video Games', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-4076186e59eea139', 'Which famous racing game series was developed by the studio Nadeo?', 'Quelle célèbre série de jeux de course a été développée par le studio Nadeo ?', '["Gran Turismo", "Need for Speed", "Forza Horizon", "TrackMania"]'::jsonb, '["Gran Turismo", "Need for Speed", "Forza Horizon", "TrackMania"]'::jsonb, 3, 'Video Games', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-56c5d9b2750ee24c', 'Which game series inspired the gameplay of Final Fantasy Explorers?', 'Quelle saga a inspiré le gameplay de Final Fantasy Explorers ?', '["Dark Souls", "Kingdom Hearts", "Dragon Quest", "Monster Hunter"]'::jsonb, '["Dark Souls", "Kingdom Hearts", "Dragon Quest", "Monster Hunter"]'::jsonb, 3, 'Video Games', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-77a54b4cc9cf4f1e', 'Final Fantasy Mystic Quest was designed to be particularly accessible for beginners.', 'Final Fantasy Mystic Quest a été conçu pour être particulièrement accessible aux joueurs débutants.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Video Games', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-48ff14999e4aef77', 'Which console marked the return of the Final Fantasy series to Nintendo home consoles with Crystal Chronicles?', 'Sur quelle console de salon Nintendo la série Final Fantasy a-t-elle fait son retour avec Crystal Chronicles ?', '["Super Nintendo", "Wii", "GameCube", "Nintendo 64"]'::jsonb, '["Super Nintendo", "Wii", "GameCube", "Nintendo 64"]'::jsonb, 2, 'Video Games', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-9570b0d25e80e929', 'Final Fantasy Adventure is the first entry in the Mana series.', 'Final Fantasy Adventure est le premier épisode de la série Mana.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Video Games', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-0ffdc75e8ad739d5', 'The Final Fantasy Legend trilogy on Game Boy actually belongs to which game series?', 'La trilogie The Final Fantasy Legend sur Game Boy appartient en réalité à quelle série de jeux ?', '["Dragon Quest", "SaGa", "Chocobo", "Mana"]'::jsonb, '["Dragon Quest", "SaGa", "Chocobo", "Mana"]'::jsonb, 1, 'Video Games', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-e041719c754114dd', 'What type of game is Dissidia: Final Fantasy?', 'Quel est le genre du jeu Dissidia: Final Fantasy ?', '["Fighting game", "Puzzle game", "Strategy game", "Racing game"]'::jsonb, '["Jeu de combat", "Jeu de réflexion", "Jeu de stratégie", "Jeu de course"]'::jsonb, 0, 'Video Games', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-be6742b958c958c6', 'What are the names of the two main factions in World of Warcraft?', 'Quels sont les noms des deux factions principales dans World of Warcraft ?', '["The Order and the Chaos", "The Alliance and the Horde", "The Light and the Void", "The Humans and the Orcs"]'::jsonb, '["L''Ordre et le Chaos", "L''Alliance et la Horde", "La Lumière et le Vide", "Les Humains et les Orcs"]'::jsonb, 1, 'Video Games', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-5737a663835bab76', 'World of Warcraft takes place in the fantasy world of Azeroth.', 'World of Warcraft se déroule dans le monde imaginaire d''Azeroth.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Video Games', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-cc0891ac89728dcc', 'Since its launch, World of Warcraft has always had a mandatory main questline.', 'Depuis sa sortie, World of Warcraft a toujours imposé une quête principale unique.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 1, 'Video Games', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-2bec81be8865a832', 'World of Warcraft is the fourth game in which series?', 'World of Warcraft est le quatrième jeu de quelle série ?', '["Overwatch", "Diablo", "Warcraft", "StarCraft"]'::jsonb, '["Overwatch", "Diablo", "Warcraft", "StarCraft"]'::jsonb, 2, 'Video Games', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-fecbe7229e169156', 'What type of game is World of Warcraft?', 'Quel est le genre de World of Warcraft ?', '["RTS", "Battle Royale", "MMORPG", "FPS"]'::jsonb, '["RTS", "Battle Royale", "MMORPG", "FPS"]'::jsonb, 2, 'Video Games', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-3217f70f58e35b86', 'Which of these races is part of the Alliance faction in World of Warcraft?', 'Parmi ces races, laquelle fait partie de l''Alliance dans World of Warcraft ?', '["Night elves", "Taurens", "Undead", "Orcs"]'::jsonb, '["Elfes de la nuit", "Taurens", "Morts-vivants", "Orcs"]'::jsonb, 0, 'Video Games', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-b6945d6ef5399caf', 'Cooking, fishing, and archaeology are considered primary professions in World of Warcraft.', 'La cuisine, la pêche et l''archéologie sont considérées comme des professions primaires dans World of Warcraft.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 1, 'Video Games', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-7f89fe61c69bbdeb', 'Which famous adventurer is the character Harrison Jones a reference to?', 'À quel célèbre aventurier le personnage Harrison Jones fait-il référence ?', '["Indiana Jones", "Lara Croft", "Nathan Drake", "Allan Quatermain"]'::jsonb, '["Indiana Jones", "Lara Croft", "Nathan Drake", "Allan Quatermain"]'::jsonb, 0, 'Video Games', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-bca795e4f22b9e55', 'Pandarens are neutral races that can choose to join either the Alliance or the Horde.', 'Les Pandarens sont une race neutre qui peut choisir de rejoindre l''Alliance ou la Horde.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Video Games', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-aa770a649704f476', 'Which of these is NOT one of the three categories for character specializations?', 'Laquelle de ces catégories ne fait pas partie des trois rôles de spécialisation ?', '["Protection", "Soin", "Dégâts", "Support"]'::jsonb, '["Protection", "Soin", "Dégâts", "Soutien"]'::jsonb, 3, 'Video Games', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-05b40dffbc996583', 'What structure must you destroy to win a game of League of Legends?', 'Quelle structure faut-il détruire pour remporter une partie de League of Legends ?', '["The Fountain", "The Turret", "The Nexus", "The Inhibitor"]'::jsonb, '["La fontaine", "La tourelle", "Le Nexus", "L''inhibiteur"]'::jsonb, 2, 'Video Games', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-a3a5a2cef5051895', 'How many players are there in each team during a standard game of League of Legends?', 'Combien de joueurs composent chaque équipe lors d''une partie classique de League of Legends ?', '["3", "6", "5", "4"]'::jsonb, '["3", "6", "5", "4"]'::jsonb, 2, 'Video Games', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-88a5984825633f0e', 'What is the name of the animated series based on the League of Legends universe?', 'Quel est le nom de la série d''animation basée sur l''univers de League of Legends ?', '["The Rift", "Nexus", "Arcane", "Runeterra"]'::jsonb, '["The Rift", "Nexus", "Arcane", "Runeterra"]'::jsonb, 2, 'Video Games', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-0a9e386f7ca7d67a', 'Teamfight Tactics is a game mode that plays exactly like the main League of Legends mode.', 'Teamfight Tactics est un mode de jeu qui se joue exactement comme le mode principal de League of Legends.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 1, 'Video Games', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-aee0d746b872d669', 'Which powerful neutral monster grants a buff that strengthens your minions?', 'Quel monstre neutre puissant confère un bonus renforçant vos sbires ?', '["Dragon Elder", "Baron Nashor", "Rift Herald", "Blue Sentinel"]'::jsonb, '["Dragon ancestral", "Baron Nashor", "Héraut de la faille", "Sentinelle bleue"]'::jsonb, 1, 'Video Games', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-9ae5db131e296bf3', 'What is the main characteristic of the ARAM game mode?', 'Quelle est la particularité principale du mode de jeu ARAM ?', '["One single lane", "Three lanes", "No jungle monsters", "Only ranged champions"]'::jsonb, '["Une seule voie", "Trois voies", "Aucun monstre dans la jungle", "Uniquement des champions à distance"]'::jsonb, 0, 'Video Games', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-c44bb03abef90c13', 'In Teamfight Tactics, players control their champions'' movements manually during combat.', 'Dans Teamfight Tactics, les joueurs contrôlent manuellement les déplacements de leurs champions pendant le combat.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 1, 'Video Games', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-1179ce4a00f82554', 'In a standard game, one player out of the five starts in the jungle.', 'Dans une partie classique, un joueur sur les cinq commence dans la jungle.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Video Games', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-897025555922e86c', 'How many players compete against each other in a game of Teamfight Tactics?', 'Combien de joueurs s''affrontent lors d''une partie de Teamfight Tactics ?', '["Eight", "Two", "Ten", "Five"]'::jsonb, '["Huit", "Deux", "Dix", "Cinq"]'::jsonb, 0, 'Video Games', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-9829aaf09f6d42a1', 'Which company produces the Mario Kart video game series?', 'Quelle entreprise produit la série de jeux vidéo Mario Kart ?', '["Sony", "Nintendo", "Sega", "Ubisoft"]'::jsonb, '["Sony", "Nintendo", "Sega", "Ubisoft"]'::jsonb, 1, 'Video Games', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-7c7675227f2fb6c8', 'What is the main goal in Mario Kart''s Battle mode?', 'Quel est l''objectif principal du mode Bataille dans Mario Kart ?', '["Pop the opponent''s balloons", "Hit the most mystery boxes", "Finish the race first", "Collect the most coins"]'::jsonb, '["Crever les ballons des adversaires", "Toucher le plus de boîtes mystères", "Finir la course en premier", "Ramasser le plus de pièces"]'::jsonb, 0, 'Video Games', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-3a7ce5a36402ae11', 'The main goal of Mario Kart is to finish the race in first place.', 'L''objectif principal de Mario Kart est de franchir la ligne d''arrivée en premier.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Video Games', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-ed1b4ab1e86d3116', 'What major technical innovation did Mario Kart 64 introduce to the series?', 'Quelle innovation technique majeure Mario Kart 64 a-t-il introduite dans la série ?', '["Voice chat", "Motion controls", "Online multiplayer", "3D graphics"]'::jsonb, '["Le chat vocal", "La détection de mouvement", "Le jeu en ligne", "Des graphismes en 3D"]'::jsonb, 3, 'Video Games', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-2eb94cad6d07fa98', 'In Mario Kart 64, coins were removed compared to the first game.', 'Dans Mario Kart 64, les pièces ont été retirées par rapport au premier jeu.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Video Games', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-326a6b9733e77d84', 'What are the items inside the cubes marked with a ''?'' called?', 'Comment appelle-t-on les cubes marqués d''un « ? » qui contiennent des objets ?', '["Mystery Blocks", "Item Boxes", "Bonus Cubes", "Power-up Crates"]'::jsonb, '["Blocs Mystères", "Boîtes à Objets", "Cubes de Pouvoir", "Caisses Bonus"]'::jsonb, 1, 'Video Games', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-6fd0f0bacd66edc4', 'Mario Kart Wii was sold with a steering wheel accessory called the Wii Wheel.', 'Mario Kart Wii était vendu avec un volant appelé le Wii Wheel.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Video Games', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-4d9514597eae5b9f', 'In Mario Kart DS, what is displayed on the bottom screen of the console?', 'Dans Mario Kart DS, que permet d''afficher l''écran du bas de la console ?', '["The cinematic replay", "The list of unlocked items", "The map of the circuit", "The player''s character"]'::jsonb, '["Le ralenti de la course", "La liste des objets débloqués", "La carte du circuit", "Le personnage du joueur"]'::jsonb, 2, 'Video Games', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-1ce6dc7a8227e23f', 'In Mario Kart Wii, races feature a total of ten competitors at the same time.', 'Dans Mario Kart Wii, les courses opposent un total de dix concurrents en simultané.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 1, 'Video Games', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-cb7bfd3fd13c8a62', 'On which circuit does the sky change color and darken with every lap?', 'Sur quel circuit le ciel change-t-il de couleur et s''assombrit-il à chaque tour ?', '["Bowser''s Castle", "Sunset Wilds", "Rainbow Road", "Luigi Circuit"]'::jsonb, '["Château de Bowser", "Pays Crépuscule", "Route Arc-en-ciel", "Circuit Luigi"]'::jsonb, 1, 'Video Games', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-7363bb4a5ba4f152', 'Which company developed and manufactured the famous Game Boy portable console?', 'Quelle entreprise a développé et fabriqué la célèbre console portable Game Boy ?', '["Atari", "Sony", "Sega", "Nintendo"]'::jsonb, '["Atari", "Sony", "Sega", "Nintendo"]'::jsonb, 3, 'Video Games', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-315c133ddb91494d', 'Which iconic game was famously bundled with the original Game Boy at its launch?', 'Quel jeu emblématique était offert avec la Game Boy originale lors de son lancement ?', '["Pokémon", "Super Mario Land", "Tetris", "The Legend of Zelda"]'::jsonb, '["Pokémon", "Super Mario Land", "Tetris", "The Legend of Zelda"]'::jsonb, 2, 'Video Games', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-39df2050bffec9a4', 'The original Game Boy featured a color screen to compete with other portable consoles.', 'La Game Boy originale possédait un écran couleur pour concurrencer les autres consoles portables.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 1, 'Video Games', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-76153bb20ddd0707', 'Who is the Nintendo engineer credited with designing the Game Boy?', 'Quel ingénieur de chez Nintendo est crédité pour la conception de la Game Boy ?', '["Shigeru Miyamoto", "Satoshi Tajiri", "Gunpei Yokoi", "Satoru Okada"]'::jsonb, '["Shigeru Miyamoto", "Satoshi Tajiri", "Gunpei Yokoi", "Satoru Okada"]'::jsonb, 2, 'Video Games', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-3d4e0d9881817bed', 'The Pokémon franchise was released on the Game Boy starting in 1996.', 'La franchise Pokémon est sortie sur Game Boy à partir de 1996.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Video Games', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-455726eebe614de5', 'Why did Gunpei Yokoi choose a monochrome screen for the Game Boy?', 'Pourquoi Gunpei Yokoi a-t-il choisi un écran monochrome pour la Game Boy ?', '["To make the screen brighter", "To improve graphic resolution", "To allow for 3D rendering", "To save battery and lower costs"]'::jsonb, '["Pour rendre l''écran plus lumineux", "Pour améliorer la résolution graphique", "Pour permettre un rendu en 3D", "Pour économiser les piles et réduire les coûts"]'::jsonb, 3, 'Video Games', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-b4797fe4b7075dd2', 'The original Game Boy screen was backlit.', 'L''écran de la Game Boy originale était rétroéclairé.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 1, 'Video Games', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-e8894b68492f67bb', 'How many AA batteries were required to power the original Game Boy?', 'Combien de piles AA fallait-il pour alimenter la Game Boy originale ?', '["2", "1", "4", "6"]'::jsonb, '["2", "1", "4", "6"]'::jsonb, 2, 'Video Games', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-becda6913162a0e6', 'What was the purpose of the Game Boy Printer accessory?', 'À quoi servait l''accessoire Game Boy Printer ?', '["Printing photos", "Playing music", "Connecting to the internet", "Charging batteries"]'::jsonb, '["Imprimer des photos", "Écouter de la musique", "Se connecter à internet", "Recharger les piles"]'::jsonb, 0, 'Video Games', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-2e8ca6dc2196dccd', 'A sewing machine was released as an official accessory for the Game Boy.', 'Une machine à coudre a été commercialisée comme accessoire officiel pour la Game Boy.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Video Games', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-652359fc2049e449', 'Which improved, smaller version of the Game Boy was released in 1996?', 'Quelle version améliorée et plus petite de la Game Boy est sortie en 1996 ?', '["Game Boy Advance", "Game Boy Color", "Game Boy Light", "Game Boy Pocket"]'::jsonb, '["Game Boy Advance", "Game Boy Color", "Game Boy Light", "Game Boy Pocket"]'::jsonb, 3, 'Video Games', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-e11169eac81ac8c8', 'What type of game is the Call of Duty series?', 'Quel est le genre de la série Call of Duty ?', '["Strategy game", "First-person shooter", "Racing game", "Role-playing game"]'::jsonb, '["Jeu de stratégie", "Jeu de tir à la première personne", "Jeu de course", "Jeu de rôle"]'::jsonb, 1, 'Video Games', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-de6f0aa4d171580b', 'Which studio developed the very first Call of Duty game?', 'Quel studio a développé le tout premier jeu Call of Duty ?', '["Sledgehammer Games", "Treyarch", "Infinity Ward", "Raven Software"]'::jsonb, '["Sledgehammer Games", "Treyarch", "Infinity Ward", "Raven Software"]'::jsonb, 2, 'Video Games', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-60943d5601ef7689', 'Call of Duty games only take place during the Second World War.', 'Les jeux Call of Duty se déroulent uniquement pendant la Seconde Guerre mondiale.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 1, 'Video Games', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-6a62d2d08c3c6773', 'Which Call of Duty game introduced the modern conflict setting to the series?', 'Quel épisode de Call of Duty a introduit le contexte de conflit moderne dans la série ?', '["Ghosts", "Black Ops", "World at War", "Modern Warfare"]'::jsonb, '["Ghosts", "Black Ops", "World at War", "Modern Warfare"]'::jsonb, 3, 'Video Games', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-31788aa492fca987', 'Call of Duty is one of the best-selling video game franchises in history.', 'Call of Duty fait partie des sagas de jeux vidéo les plus vendues de l''histoire.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Video Games', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-1a4119ecb2d47478', 'Which of these criticisms is often leveled at the Call of Duty series?', 'Quelle critique est régulièrement adressée à la série Call of Duty ?', '["It is too easy to complete", "It is only available on consoles", "It is suspected of encouraging aggression", "It has poor graphics quality"]'::jsonb, '["Elle est trop facile à terminer", "Elle n''est disponible que sur consoles", "Elle est soupçonnée de favoriser l''agressivité", "La qualité graphique est médiocre"]'::jsonb, 2, 'Video Games', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-18ec1ebba1914b92', 'The Call of Duty series was initially compared to the Medal of Honor franchise.', 'La série Call of Duty était initialement comparée à la franchise Medal of Honor.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Video Games', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-30c47d59be973cf8', 'What is the name of the digital platform created by Activision-Blizzard?', 'Quel est le nom de la plateforme numérique créée par Activision-Blizzard ?', '["Battle.net", "Origin", "Steam", "Epic Games Store"]'::jsonb, '["Battle.net", "Origin", "Steam", "Epic Games Store"]'::jsonb, 0, 'Video Games', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-ef10b4890864dcb5', 'What product did Nintendo originally manufacture when it was founded in 1889?', 'Quel type de produit Nintendo fabriquait-il à sa création en 1889 ?', '["Mechanical toys", "Hanafuda playing cards", "Rice portions", "Arcade cabinets"]'::jsonb, '["Des jouets mécaniques", "Des cartes à jouer Hanafuda", "Des portions de riz", "Des bornes d''arcade"]'::jsonb, 1, 'Video Games', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-31a9688096c65e91', 'What is the literal meaning of the name ''Nintendo'' based on its three kanji characters?', 'Que signifie littéralement le nom « Nintendo » d''après ses trois kanjis ?', '["The sky of endless games", "The hall where heaven is entrusted", "The path of digital luck", "The house of playing cards"]'::jsonb, '["Le ciel des jeux infinis", "La salle où l''on confie au ciel", "Le chemin de la chance numérique", "La maison des cartes à jouer"]'::jsonb, 1, 'Video Games', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-63aa0130f3055212', 'Which company did Nintendo partner with in 1959 to boost the popularity of its playing cards?', 'Avec quelle entreprise Nintendo a-t-il signé un contrat en 1959 pour doper ses ventes de cartes à jouer ?', '["Magnavox", "Disney", "NPD Group", "Universal"]'::jsonb, '["Magnavox", "Disney", "NPD Group", "Universal"]'::jsonb, 1, 'Video Games', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-62bcb2c9e8b6ddd7', 'Before focusing on video games, Nintendo once sold individual rice portions.', 'Avant de se consacrer aux jeux vidéo, Nintendo a commercialisé des portions de riz individuelles.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Video Games', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-37e6af008fd9ef63', 'Gunpei Yokoi was originally hired by Nintendo as a lead video game designer.', 'Gunpei Yokoi a été embauché par Nintendo en tant que concepteur principal de jeux vidéo.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 1, 'Video Games', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-608ed10b65d9c371', 'What was the name of the first successful toy created by Gunpei Yokoi for Nintendo?', 'Quel est le nom du premier jouet à succès créé par Gunpei Yokoi pour Nintendo ?', '["Color TV-Game", "Love Tester", "Ultra Machine", "Ultra Hand"]'::jsonb, '["Color TV-Game", "Love Tester", "Ultra Machine", "Ultra Hand"]'::jsonb, 3, 'Video Games', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-76a9d92f8865eab9', 'What was the name of Nintendo''s first home video game console released in 1977?', 'Quel était le nom de la première console de salon commercialisée par Nintendo en 1977 ?', '["Color TV-Game 6", "Magnavox Odyssey", "Game & Watch", "Famicom"]'::jsonb, '["Color TV-Game 6", "Magnavox Odyssey", "Game & Watch", "Famicom"]'::jsonb, 0, 'Video Games', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-ce86d0a83243378f', 'Gunpei Yokoi is the inventor of the D-pad (directional pad).', 'Gunpei Yokoi est l''inventeur de la croix directionnelle.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Video Games', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-e61a45639d89a605', 'Which portable device inspired Gunpei Yokoi to create the Game & Watch series?', 'Quel appareil portable a inspiré Gunpei Yokoi pour créer la gamme des Game & Watch ?', '["A radio", "A portable television", "A digital watch", "A calculator"]'::jsonb, '["Une radio", "Une télévision portable", "Une montre numérique", "Une calculatrice"]'::jsonb, 3, 'Video Games', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-322145f45a92d762', 'Nintendo of America was originally headquartered in New York.', 'Le siège social de Nintendo of America était initialement situé à New York.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Video Games', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-cef975c22eaf9992', 'Which board game inspired Nintendo''s 1978 arcade title ''Computer Othello''?', 'Quel jeu de société a inspiré le titre d''arcade ''Computer Othello'' sorti par Nintendo en 1978 ?', '["Backgammon", "Othello", "Checkers", "Chess"]'::jsonb, '["Backgammon", "Othello", "Dames", "Échecs"]'::jsonb, 1, 'Video Games', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-1a9c010af1772c49', 'Which company supplied the microprocessors for the early Nintendo Color TV-Game consoles?', 'Quelle entreprise fournissait les microprocesseurs pour les premières consoles Nintendo Color TV-Game ?', '["Mitsubishi", "Sony", "Sharp", "NEC"]'::jsonb, '["Mitsubishi", "Sony", "Sharp", "NEC"]'::jsonb, 0, 'Video Games', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-1ad6bc7578f7c723', 'What is the full English expression that gives its name to the Pokémon franchise?', 'Quelle est l''expression anglaise complète à l''origine du nom de la franchise Pokémon ?', '["Pocket Monsters", "Pocket Fighters", "Pocket Creatures", "Pocket Animals"]'::jsonb, '["Pocket Monsters", "Pocket Fighters", "Pocket Creatures", "Pocket Animals"]'::jsonb, 0, 'Video Games', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-0ddcbaa5d019dde3', 'Under what condition does a Pokémon battle officially end?', 'Dans quelle condition un match Pokémon se termine-t-il officiellement ?', '["When a trainer surrenders", "When all of a trainer''s Pokémon are KO", "When the time limit is reached", "When a Pokémon faints"]'::jsonb, '["Quand un dresseur abandonne", "Quand tous les Pokémon d''un dresseur sont KO", "Quand le temps imparti est écoulé", "Quand un seul Pokémon est battu"]'::jsonb, 1, 'Video Games', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-b5beda59d985782a', 'In the animated series, most Pokémon are capable of speaking human languages fluently.', 'Dans la série animée, la plupart des Pokémon sont capables de parler couramment les langues humaines.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 1, 'Video Games', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-d85999325be5bed4', 'A basic Pokémon can evolve a maximum of two times.', 'Un Pokémon de base peut évoluer au maximum deux fois.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Video Games', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-a00525c4c82a1430', 'Before facing the League Champion, a trainer must defeat the group known as the Elite Four.', 'Avant d''affronter le Maître de la Ligue, un dresseur doit battre le groupe appelé le Conseil 4.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Video Games', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-3a4abf7681c95d53', 'Which specific new gameplay feature was introduced in the 2003 games Pokémon Ruby and Sapphire?', 'Quel nouveau concept de jeu a été introduit dans les versions Rubis et Saphir sorties en 2003 ?', '["Regional Forms", "Pokéblocks", "Dynamax", "Z-Moves"]'::jsonb, '["Les formes régionales", "Les PokéBlocs", "Le Dynamax", "Les capacités Z"]'::jsonb, 1, 'Video Games', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-aeaef22c20949e0e', 'Pokémon FireRed and LeafGreen were released as remakes of the original first-generation games.', 'Les jeux Pokémon Rouge Feu et Vert Feuille sont sortis en tant que remakes des jeux originaux de la première génération.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Video Games', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-d05d77224bc6df26', 'Who inspired the name of Princess Zelda in the video game series?', 'Qui a inspiré le prénom de la princesse Zelda dans la célèbre saga ?', '["Zelda Rubinstein", "Zelda Sayre", "Zelda Williams", "Zelda Fitzgerald"]'::jsonb, '["Zelda Rubinstein", "Zelda Sayre", "Zelda Williams", "Zelda Fitzgerald"]'::jsonb, 3, 'Video Games', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-d43d4fe6f03d1f39', 'Which literary work inspired Takashi Tezuka for the setting and scenario of The Legend of Zelda?', 'Quelle œuvre littéraire a inspiré Takashi Tezuka pour le décor et le scénario de The Legend of Zelda ?', '["Dune", "The Chronicles of Narnia", "The Hobbit", "The Lord of the Rings"]'::jsonb, '["Dune", "Le Monde de Narnia", "Bilbo le Hobbit", "Le Seigneur des anneaux"]'::jsonb, 3, 'Video Games', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-98f98430ee3ff270', 'What animal does Ganon resemble in his monster form within the Zelda series?', 'À quel animal Ganon ressemble-t-il dans sa forme de monstre au sein de la saga Zelda ?', '["Wolf", "Bear", "Boar", "Dragon"]'::jsonb, '["Loup", "Ours", "Sanglier", "Dragon"]'::jsonb, 2, 'Video Games', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-75f60e8f1d0de817', 'Princess Zelda appears in every single game of the main series.', 'La princesse Zelda apparaît dans absolument tous les jeux de la saga principale.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 1, 'Video Games', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-00b849043c17d6e5', 'Which of these mythologies did NOT influence the creation of The Legend of Zelda series?', 'Laquelle de ces mythologies n''a PAS influencé la création de la saga The Legend of Zelda ?', '["Norse mythology", "Celtic mythology", "Japanese mythology", "Egyptian mythology"]'::jsonb, '["Mythologie nordique", "Mythologie celtique", "Mythologie japonaise", "Mythologie égyptienne"]'::jsonb, 3, 'Video Games', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-00b2f5a1146afd0e', 'Which Zelda game is unique for being categorized as an action-RPG due to its experience points and leveling system?', 'Quel jeu Zelda est le seul à être classé comme un action-RPG grâce à son système de points d''expérience et de niveaux ?', '["A Link to the Past", "Ocarina of Time", "Twilight Princess", "The Adventure of Link"]'::jsonb, '["A Link to the Past", "Ocarina of Time", "Twilight Princess", "The Adventure of Link"]'::jsonb, 3, 'Video Games', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-bdc3cf5d62ee88b1', 'In the Legend of Zelda series, which entity do you typically defeat to obtain the unique item hidden within a dungeon?', 'Dans la série Zelda, quel adversaire faut-il généralement vaincre pour obtenir l''objet unique caché dans un donjon ?', '["A mini-boss", "A merchant", "The final boss", "A sage"]'::jsonb, '["Un mini-boss", "Un marchand", "Le boss final", "Un sage"]'::jsonb, 0, 'Video Games', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-b45a65c14abad8af', 'Which iconic companion is Link able to ride in games like Ocarina of Time and Twilight Princess?', 'Quel compagnon emblématique Link peut-il chevaucher dans des jeux comme Ocarina of Time et Twilight Princess ?', '["Midona", "Navi", "Tatl", "Epona"]'::jsonb, '["Midona", "Navi", "Tatl", "Epona"]'::jsonb, 3, 'Video Games', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-aab5984b272578f3', 'Which Super Mario game introduced a non-linear map-based progression for the first time?', 'Quel jeu Super Mario a introduit pour la première fois une progression non linéaire basée sur une carte ?', '["Super Mario 64", "Super Mario Bros.", "Super Mario Bros. 3", "Super Mario World"]'::jsonb, '["Super Mario 64", "Super Mario Bros.", "Super Mario Bros. 3", "Super Mario World"]'::jsonb, 2, 'Video Games', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-19fdc572bd0b826c', 'Why was the Super Mushroom power-up originally created by Shigeru Miyamoto?', 'Pourquoi le Super Champignon a-t-il été créé par Shigeru Miyamoto à l''origine ?', '["To make him run faster", "To allow him to fly", "Because Mario was too big", "To survive underwater"]'::jsonb, '["Pour le faire courir plus vite", "Pour lui permettre de voler", "Parce que Mario était trop grand", "Pour survivre sous l''eau"]'::jsonb, 2, 'Video Games', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-e88c7c4b6e60a547', 'The desert zone has been present in the Super Mario series since the very first game.', 'La zone désertique est présente dans la série Super Mario depuis le tout premier jeu.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 1, 'Video Games', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-c012e082c0b6472b', 'In Super Mario World, the path you take on the map is determined by which exit you use in a level.', 'Dans Super Mario World, le chemin que vous empruntez sur la carte est déterminé par la sortie que vous utilisez dans un niveau.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Video Games', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-a666f2949d64f3ff', 'Which of these elements made its first appearance in Super Mario World?', 'Lequel de ces éléments est apparu pour la première fois dans Super Mario World ?', '["Water levels", "Warp zones", "Haunted mansions", "Floating fortresses"]'::jsonb, '["Les zones aquatiques", "Les warp zones", "Les manoirs hantés", "Les forteresses volantes"]'::jsonb, 2, 'Video Games', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-6b226fb19cb2709a', 'Mario performs a somersault after touching a Super Star only in Super Mario Bros. 3.', 'Mario effectue un saut périlleux après avoir touché une super étoile uniquement dans Super Mario Bros. 3.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Video Games', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-8f2f25401d46521e', 'The Tanooki suit allows Mario to turn into an invincible statue for about ten seconds.', 'Le costume tanooki permet à Mario de se transformer en statue invincible pendant environ dix secondes.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 1, 'Video Games', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-dd0f0757c8b5ed9e', 'The PlayStation project originally started as a collaboration between Sony and Nintendo.', 'Le projet PlayStation a débuté à l''origine comme une collaboration entre Sony et Nintendo.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Video Games', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-ec6af655e37d8350', 'Before Sony used the name, which company originally held the trademark for ''PlayStation''?', 'Avant que Sony n''utilise ce nom, quelle entreprise détenait à l''origine la marque déposée « PlayStation » ?', '["Panasonic", "Philips", "Sega", "Yamaha"]'::jsonb, '["Panasonic", "Philips", "Sega", "Yamaha"]'::jsonb, 3, 'Video Games', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-f42462b251d0a5ad', 'After breaking ties with Sony, Nintendo signed a contract to develop a CD-ROM console with Panasonic.', 'Après avoir rompu ses liens avec Sony, Nintendo a signé un contrat pour développer une console CD-ROM avec Panasonic.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 1, 'Video Games', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-df2d8fe9c05cc944', 'What type of graphics was the PlayStation architecture specifically designed to prioritize?', 'Sur quel type de graphismes l''architecture de la PlayStation était-elle spécifiquement conçue pour mettre l''accent ?', '["2D sprite-based", "Hand-drawn animation", "Vector wireframe", "3D polygonal"]'::jsonb, '["2D basée sur des sprites", "Animation dessinée à la main", "Fil de fer vectoriel", "3D polygonale"]'::jsonb, 3, 'Video Games', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-0ef5803b52e838dd', 'What was the name of the project that the American branch of Sony proposed as an alliance with Sega?', 'Quel était le nom du projet de console que la branche américaine de Sony avait envisagé de créer en s''associant avec Sega ?', '["Sega-Sony Interactive Unit", "CD-ROM Game Station", "Sega Multimedia Entertainment System", "Sony PlayStation Pro"]'::jsonb, '["Sega-Sony Interactive Unit", "CD-ROM Game Station", "Sega Multimedia Entertainment System", "Sony PlayStation Pro"]'::jsonb, 2, 'Video Games', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-345bd33a297401af', 'It was the success of the arcade game Virtua Fighter that convinced Sony to focus the PlayStation on 3D polygonal graphics.', 'C''est le succès du jeu d''arcade Virtua Fighter qui a convaincu Sony de concentrer la PlayStation sur les graphismes en 3D polygonale.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Video Games', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-bf7bf663ce4aeb5f', 'To which division did Norio Ohga transfer Ken Kutaragi and his team to protect the PlayStation project?', 'Vers quelle division Norio Ohga a-t-il transféré Ken Kutaragi et son équipe pour préserver le projet PlayStation ?', '["Sony Music Entertainment Japan", "Sony Electronics", "Sony Semi-conductors", "Sony Pictures"]'::jsonb, '["Sony Music Entertainment Japan", "Sony Electronics", "Sony Semi-conductors", "Sony Pictures"]'::jsonb, 0, 'Video Games', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-9b20e8f8104bbb38', 'The board of directors of Sega of America was the one that rejected the proposal to create a console with Sony.', 'Le conseil d''administration de Sega of America est celui qui a rejeté la proposition de créer une console avec Sony.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 1, 'Video Games', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-ccb213b72ae0908a', 'Who was the founder of Epic/Sony Records that collaborated with Ken Kutaragi on the PlayStation project?', 'Qui était le fondateur d''Epic/Sony Records ayant collaboré avec Ken Kutaragi sur le projet PlayStation ?', '["Norio Ohga", "Howard Lincoln", "Akira Sato", "Shigeo Maruyama"]'::jsonb, '["Norio Ohga", "Howard Lincoln", "Akira Sato", "Shigeo Maruyama"]'::jsonb, 3, 'Video Games', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-1ee59774fbe9822e', 'Which family founded the company Ubisoft in 1986?', 'Quelle famille a fondé l''entreprise Ubisoft en 1986 ?', '["The Guillemot brothers", "The Clancy brothers", "The Ancel brothers", "The Byte brothers"]'::jsonb, '["Les frères Guillemot", "Les frères Clancy", "Les frères Ancel", "Les frères Byte"]'::jsonb, 0, 'Video Games', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-e62686ab77c88b81', 'Which iconic character became the official mascot of Ubisoft following its worldwide success?', 'Quel personnage emblématique est devenu la mascotte officielle d''Ubisoft suite à son succès mondial ?', '["Altaïr", "Sam Fisher", "Ezio Auditore", "Rayman"]'::jsonb, '["Altaïr", "Sam Fisher", "Ezio Auditore", "Rayman"]'::jsonb, 3, 'Video Games', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-20e60a1837305d73', 'Ubisoft''s first studio on the American continent was opened in Montreal.', 'Le premier studio d''Ubisoft sur le continent américain a été ouvert à Montréal.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Video Games', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-21edc4bac347447d', 'The name ''Ubi'' in Ubisoft is officially an acronym for ''Union des Bretons Indépendants''.', 'Le nom ''Ubi'' chez Ubisoft est officiellement l''acronyme de ''Union des Bretons Indépendants''.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 1, 'Video Games', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-18fb3a7e0c15a8a9', 'Which famous author founded the studio Red Storm Entertainment, later acquired by Ubisoft?', 'Quel célèbre écrivain a fondé le studio Red Storm Entertainment, racheté plus tard par Ubisoft ?', '["Michel Ancel", "John Romero", "Tom Clancy", "Yves Guillemot"]'::jsonb, '["Michel Ancel", "John Romero", "Tom Clancy", "Yves Guillemot"]'::jsonb, 2, 'Video Games', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-a8fd079b9311aadc', 'What type of game is the franchise Just Dance?', 'Quel est le genre du jeu Just Dance ?', '["Stealth game", "Racing game", "Rhythm game", "Action-adventure"]'::jsonb, '["Jeu d''infiltration", "Jeu de course", "Jeu de rythme", "Action-aventure"]'::jsonb, 2, 'Video Games', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-48a70cf8d6329900', 'Assassin''s Creed was first released in 2007.', 'Le jeu Assassin''s Creed est sorti pour la première fois en 2007.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Video Games', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-612bebe712d4fb1a', 'In 2004, the Guillemot brothers were the majority shareholders of Ubisoft, owning more than 50% of the company.', 'En 2004, les frères Guillemot étaient les actionnaires majoritaires d''Ubisoft, possédant plus de 50 % de l''entreprise.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 1, 'Video Games', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-4e1c7232435792ed', 'Ubisoft Motion Pictures was created to help adapt video game franchises for film and television.', 'Ubisoft Motion Pictures a été créée pour aider à adapter les franchises de jeux vidéo au cinéma et à la télévision.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Video Games', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-c9c92da3fc8313a7', 'What is the highest point in France?', 'Quel est le point culminant de la France ?', '["Pic du Midi", "Mont Blanc", "Mont Ventoux", "Puy de Dôme"]'::jsonb, '["Le pic du Midi", "Le mont Blanc", "Le mont Ventoux", "Le puy de Dôme"]'::jsonb, 1, 'Geography', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-f139f44187bee84e', 'In Metropolitan France, no point is located more than 400 km from a coast.', 'En France métropolitaine, aucun point n''est situé à plus de 400 km d''une côte.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Geography', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-b387f2f154bb1dea', 'France is considered the second largest maritime power in the world, mainly due to its:', 'La France est considérée comme la deuxième puissance maritime mondiale, principalement grâce à :', '["Naval military base", "Overseas territories", "Fishing fleet", "Merchant navy"]'::jsonb, '["Sa base navale militaire", "Ses territoires d''outre-mer", "Sa flotte de pêche", "Sa marine marchande"]'::jsonb, 1, 'Geography', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-f1ec4363c0d6ca22', 'Which mountain range is home to the Puy de Sancy, the highest point in the Massif Central?', 'Dans quel massif se trouve le puy de Sancy, point culminant du Massif central ?', '["Pyrenees", "Vosges", "Alpes", "Massif Central"]'::jsonb, '["Pyrénées", "Vosges", "Alpes", "Massif central"]'::jsonb, 3, 'Geography', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-341a50c2535ecec1', 'Which active volcano is located on the island of Reunion?', 'Quel volcan actif se trouve sur l''île de La Réunion ?', '["La Soufrière", "Mont Panié", "Piton de la Fournaise", "Montagne Pelée"]'::jsonb, '["La Soufrière", "Mont Panié", "Piton de la Fournaise", "Montagne Pelée"]'::jsonb, 2, 'Geography', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-4701605c84e4fef4', 'The highest peak in Corsica is the Monte Cinto.', 'Le Monte Cinto est le point culminant de la Corse.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Geography', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-889f932647f2be16', 'What is the approximate altitude of the Montagne Pelée in Martinique?', 'Quelle est l''altitude approximative de la Montagne Pelée en Martinique ?', '["700 meters", "3 071 meters", "1 397 meters", "2 621 meters"]'::jsonb, '["700 mètres", "3 071 mètres", "1 397 mètres", "2 621 mètres"]'::jsonb, 2, 'Geography', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-d89f04b7ce237a36', 'The Paris Basin and the Aquitaine Basin are known for their high mountain peaks.', 'Le Bassin parisien et le Bassin aquitain sont connus pour leurs sommets de haute montagne.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 1, 'Geography', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-f02336819a637e93', 'Which mountain range is the Mont Blanc the highest peak of?', 'De quelle chaîne de montagnes le mont Blanc est-il le point culminant ?', '["The Massif Central", "The Alps", "The Pyrenees", "The Jura Mountains"]'::jsonb, '["Le Massif central", "Les Alpes", "Les Pyrénées", "Le Jura"]'::jsonb, 1, 'Geography', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-e24cf4f40799f873', 'Before being called ''Mont Blanc'', what was the mountain famously nicknamed?', 'Avant d''être appelé « mont Blanc », quel était le surnom célèbre de la montagne ?', '["The White Peak", "The Sleeping Sentinel", "The Cursed Mountain", "The Frozen Giant"]'::jsonb, '["Le Pic blanc", "La Sentinelle endormie", "La montagne Maudite", "Le Géant gelé"]'::jsonb, 2, 'Geography', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-82dc778047fb7d00', 'The Mont Blanc is considered the highest peak in Western Europe.', 'Le mont Blanc est considéré comme le plus haut sommet d''Europe occidentale.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Geography', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-b7123feb4af475c7', 'The first recorded ascent of the Mont Blanc took place in the 19th century.', 'La première ascension du mont Blanc a eu lieu au XIXe siècle.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 1, 'Geography', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-bc1397373aa51099', 'Which of these peaks is located in the Mont Blanc massif?', 'Lequel de ces sommets se trouve dans le massif du Mont-Blanc ?', '["Puy de Dôme", "Aiguille du Midi", "Mont Aigoual", "Grand Ballon"]'::jsonb, '["Puy de Dôme", "Aiguille du Midi", "Mont Aigoual", "Grand Ballon"]'::jsonb, 1, 'Geography', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-b44cc46f10985df3', 'In relation to the snowy peak, where is the rocky summit of the Mont Blanc located?', 'Par rapport au sommet enneigé, où se situe le sommet rocheux du mont Blanc ?', '["Directly underneath", "To the west", "To the north", "To the east"]'::jsonb, '["Juste en dessous", "À l''ouest", "Au nord", "À l''est"]'::jsonb, 1, 'Geography', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-4cb00b5769725d0d', 'Due to pollution, the visibility from the top of the Mont Blanc can drop to 50 km.', 'À cause de la pollution, la visibilité depuis le sommet du mont Blanc peut descendre à 50 km.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 1, 'Geography', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-2e0f218d80833489', 'What shape do the slopes of the Mont Blanc form?', 'Quelle forme les versants du mont Blanc forment-ils ?', '["A cylinder", "A cube", "A pyramid", "A sphere"]'::jsonb, '["Un cylindre", "Un cube", "Une pyramide", "Une sphère"]'::jsonb, 2, 'Geography', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-91e9e24b07b61eeb', 'In which French department does the Loire river take its source?', 'Dans quel département français la Loire prend-elle sa source ?', '["Loire", "Ardèche", "Maine-et-Loire", "Loiret"]'::jsonb, '["Loire", "Ardèche", "Maine-et-Loire", "Loiret"]'::jsonb, 1, 'Geography', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-b7a02adf0f2f9bd5', 'The name ''Loire'' likely comes from a Gaulish word meaning what?', 'Le nom « Loire » viendrait d''un mot gaulois désignant quoi ?', '["A deep valley", "The wind", "A winding path", "Mud or silt"]'::jsonb, '["Une vallée profonde", "Le vent", "Un chemin sinueux", "La vase ou le limon"]'::jsonb, 3, 'Geography', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-808bf55cb614f21d', 'The Loire river flows into the Mediterranean Sea.', 'Le fleuve de la Loire se jette dans la mer Méditerranée.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 1, 'Geography', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-b8444ec31454a101', 'The term ''Ligériens'' is the demonym used for people living in the Loire basin.', 'Le terme « Ligériens » est le gentilé utilisé pour désigner les habitants du bassin de la Loire.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Geography', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-6881f2f4310b906c', 'The general profile of the Loire river is often compared to what object?', 'À quel objet compare-t-on souvent le profil général de la Loire ?', '["A ribbon", "A snake", "A lightning bolt", "A staircase"]'::jsonb, '["Un ruban", "Un serpent", "Un éclair", "Un escalier"]'::jsonb, 3, 'Geography', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-b06f500d4bff53d9', 'Where can you find the ''geographic source'' of the Loire?', 'Où se trouve la « source géographique » de la Loire ?', '["Under a church", "Inside a castle", "In a public park", "Inside a cow barn"]'::jsonb, '["Sous une église", "Dans un château", "Dans un parc public", "Dans une étable à vaches"]'::jsonb, 3, 'Geography', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-575d313ea3610505', 'The bed of the Loire river is known for its permanent stability.', 'Le lit du fleuve de la Loire est réputé pour sa stabilité permanente.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 1, 'Geography', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-c6a08ce01db7b9b7', 'According to a geological hypothesis, the ''paléo-Loire'' originally flowed into which river?', 'Selon une hypothèse géologique, la « paléo-Loire » se jetait autrefois dans quel fleuve ?', '["The Rhône", "The Seine", "The Rhine", "The Garonne"]'::jsonb, '["Le Rhône", "La Seine", "Le Rhin", "La Garonne"]'::jsonb, 1, 'Geography', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-8d5c59dd1fd6a3d9', 'Which of these is a French region?', 'Laquelle de ces régions est une région française ?', '["Occitanie", "Bavaria", "Catalonia", "Tuscany"]'::jsonb, '["Occitanie", "Bavière", "Catalogne", "Toscane"]'::jsonb, 0, 'Geography', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-793502c19730cc36', 'Provence-Alpes-Côte d''Azur is a region in France.', 'Provence-Alpes-Côte d''Azur est une région de France.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Geography', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-064fa209d2b7a696', 'Auvergne-Rhône-Alpes is a region located in the north of France.', 'Auvergne-Rhône-Alpes est une région située dans le nord de la France.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 1, 'Geography', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-9663db8e48c2c4d0', 'Which of these regions is located in the northern half of France?', 'Laquelle de ces régions se situe dans la moitié nord de la France ?', '["Corsica", "Occitanie", "Hauts-de-France", "Provence-Alpes-Côte d''Azur"]'::jsonb, '["Corse", "Occitanie", "Hauts-de-France", "Provence-Alpes-Côte d''Azur"]'::jsonb, 2, 'Geography', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-e762a3ee461bc72f', 'Mayotte is one of the French overseas regions.', 'Mayotte fait partie des régions françaises d''outre-mer.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Geography', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-dd24aea89091e0ad', 'Which of these French overseas territories is located on the South American continent?', 'Lequel de ces territoires français d''outre-mer se situe sur le continent sud-américain ?', '["Réunion", "Martinique", "French Guiana", "Guadeloupe"]'::jsonb, '["La Réunion", "La Martinique", "La Guyane", "La Guadeloupe"]'::jsonb, 2, 'Geography', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-a6b6175c745ef6ba', 'Most French overseas territories are islands or archipelagos.', 'La plupart des territoires français d''outre-mer sont des îles ou des archipels.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Geography', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-55dbfc493d9457a2', 'Which of these territories was part of the first French colonial empire?', 'Lequel de ces territoires faisait partie du premier empire colonial français ?', '["New Caledonia", "Réunion", "Wallis and Futuna", "French Polynesia"]'::jsonb, '["La Nouvelle-Calédonie", "La Réunion", "Wallis-et-Futuna", "La Polynésie française"]'::jsonb, 1, 'Geography', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-fae6b107242a0ec5', 'Mayotte became independent from France in 1975 after a referendum.', 'Mayotte a pris son indépendance vis-à-vis de la France en 1975 suite à un référendum.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 1, 'Geography', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-1183f480ed99fbd4', 'Which nationalist leader campaigned for Madagascar to become a French department in the 1920s?', 'Quel leader nationaliste a milité dans les années 1920 pour que Madagascar devienne un département français ?', '["Victor Schoelcher", "Jean Ralaimongo", "Charles de Gaulle", "Bernard Cornut-Gentille"]'::jsonb, '["Victor Schoelcher", "Jean Ralaimongo", "Charles de Gaulle", "Bernard Cornut-Gentille"]'::jsonb, 1, 'Geography', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-677dedca4779a774', 'Approximately how far is New Caledonia from Paris?', 'À quelle distance approximative de Paris se trouve la Nouvelle-Calédonie ?', '["12 000 km", "6 800 km", "20 000 km", "16 800 km"]'::jsonb, '["12 000 km", "6 800 km", "20 000 km", "16 800 km"]'::jsonb, 3, 'Geography', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-45d76f7970a9837f', 'How many referendums on independence were held in New Caledonia between 2018 and 2021?', 'Combien de référendums sur l''indépendance ont été organisés en Nouvelle-Calédonie entre 2018 et 2021 ?', '["2", "4", "3", "1"]'::jsonb, '["2", "4", "3", "1"]'::jsonb, 2, 'Geography', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-f2d4fec5940e975e', 'Madagascar claims sovereignty over the Scattered Islands (Îles Éparses).', 'Madagascar revendique la souveraineté sur les îles Éparses.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Geography', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-236e9d62a2059bd1', 'In 2010, French Guiana and Martinique voted to become overseas collectivities (COM).', 'En 2010, la Guyane et la Martinique ont voté pour devenir des collectivités d''outre-mer (COM).', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 1, 'Geography', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-690a25fb931223c1', 'What is the name of the famous and demanding hiking trail crossing Corsica?', 'Quel est le nom du célèbre sentier de grande randonnée qui traverse la Corse ?', '["GR10", "GR20", "GR5", "GR34"]'::jsonb, '["GR10", "GR20", "GR5", "GR34"]'::jsonb, 1, 'Geography', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-c42f35481797dd59', 'Napoleon Bonaparte was born in the city of Ajaccio.', 'Napoléon Bonaparte est né dans la ville d''Ajaccio.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Geography', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-2754ef8dd5c576b7', 'What major political milestone did the Corsican Republic achieve between 1755 and 1769?', 'Quel événement politique majeur la République corse a-t-elle instauré entre 1755 et 1769 ?', '["The abolition of the monarchy", "The first modern democratic constitution", "The total independence from Italy", "The creation of a unified parliament"]'::jsonb, '["L''abolition de la monarchie", "La première constitution démocratique moderne", "L''indépendance totale vis-à-vis de l''Italie", "La création d''un parlement unifié"]'::jsonb, 1, 'Geography', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-66674683009e6274', 'Which foreign power controlled Corsica for nearly four centuries starting in the 15th century?', 'Quelle puissance étrangère a contrôlé la Corse pendant près de quatre siècles à partir du XVe siècle ?', '["The Republic of Genoa", "The Roman Empire", "The Ottoman Empire", "The Kingdom of Spain"]'::jsonb, '["La république de Gênes", "L''Empire romain", "L''Empire ottoman", "Le royaume d''Espagne"]'::jsonb, 0, 'Geography', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-f0f1669cf8214af4', 'In which sea is the island of Corsica located?', 'Dans quelle mer se situe l''île de Corse ?', '["Mediterranean Sea", "Aegean Sea", "Adriatic Sea", "Atlantic Ocean"]'::jsonb, '["La mer Méditerranée", "La mer Égée", "La mer Adriatique", "L''océan Atlantique"]'::jsonb, 0, 'Geography', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-c5c458b76de87c4b', 'What is the name of the strait that separates Corsica from Sardinia?', 'Comment s''appelle le détroit qui sépare la Corse de la Sardaigne ?', '["Strait of Bonifacio", "Strait of Messina", "Strait of Gibraltar", "Strait of Otranto"]'::jsonb, '["Les bouches de Bonifacio", "Le détroit de Messine", "Le détroit de Gibraltar", "Le détroit d''Otrante"]'::jsonb, 0, 'Geography', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-de926938e22b7f78', 'Corsica is longer from north to south than it is wide at its widest point.', 'La Corse est plus longue du nord au sud qu''elle n''est large à son point le plus large.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Geography', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-6762ba910ecb0bca', 'The entire island of Corsica is composed of plains.', 'L''intégralité du territoire corse est composée de plaines.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 1, 'Geography', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-c9f3a431ecb66653', 'Which city is the main center of the ''Deçà des Monts'' (northern Corsica)?', 'Quelle ville est le centre principal du « Deçà des Monts » (nord de la Corse) ?', '["Porto-Vecchio", "Calvi", "Bastia", "Ajaccio"]'::jsonb, '["Porto-Vecchio", "Calvi", "Bastia", "Ajaccio"]'::jsonb, 2, 'Geography', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-653ddee3377dcf7f', 'Which country is considered the cultural cradle of Europe?', 'Quel pays est considéré comme le berceau culturel de l''Europe ?', '["Italy", "Greece", "Spain", "France"]'::jsonb, '["L''Italie", "La Grèce", "L''Espagne", "La France"]'::jsonb, 1, 'Geography', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-bf24fbd9091a6a51', 'The majority of Europe experiences a temperate climate.', 'La majorité du territoire européen possède un climat tempéré.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Geography', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-6da9ce0fe2703dab', 'Which mountain range traditionally marks the eastern border of Europe?', 'Quel massif montagneux marque traditionnellement la frontière est de l''Europe ?', '["The Ural Mountains", "The Pyrenees", "The Alps", "The Carpathians"]'::jsonb, '["Les monts Oural", "Les Pyrénées", "Les Alpes", "Les Carpates"]'::jsonb, 0, 'Geography', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-9517bbb9e647185f', 'Christianity began to spread across Europe starting in the 5th century.', 'Le christianisme a commencé à se diffuser en Europe à partir du Ve siècle.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 1, 'Geography', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-08b756d2494299db', 'In 1054, a schism separated Western Christians from which other group?', 'En 1054, un schisme a séparé les chrétiens d''Occident de quel autre groupe ?', '["Anglican Christians", "Evangelical Christians", "Protestant Christians", "Orthodox Christians"]'::jsonb, '["Les chrétiens anglicans", "Les chrétiens évangéliques", "Les chrétiens protestants", "Les chrétiens orthodoxes"]'::jsonb, 3, 'Geography', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-e186730fff16c069', 'Which ancient human species native to Europe was replaced by Sapiens?', 'Quelle ancienne espèce humaine originaire d''Europe a été remplacée par Sapiens ?', '["Australopithecus", "Homo erectus", "Neanderthal", "Homo habilis"]'::jsonb, '["Australopithèque", "Homo erectus", "Néandertal", "Homo habilis"]'::jsonb, 2, 'Geography', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-daa65bae5140da3e', 'In Greek mythology, under what animal form did Zeus disguise himself to abduct the princess Europe?', 'Dans la mythologie grecque, sous quelle forme animale Zeus se déguise-t-il pour enlever la princesse Europe ?', '["A swan", "A dolphin", "An eagle", "A bull"]'::jsonb, '["Un cygne", "Un dauphin", "Un aigle", "Un taureau"]'::jsonb, 3, 'Geography', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-8403d0410c5eef31', 'Iceland is considered a European country, even though it is located on the geological divide between Eurasia and America.', 'L''Islande est considérée comme un pays européen, bien qu''elle soit située sur la séparation géologique entre l''Eurasie et l''Amérique.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Geography', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-54e9217497390279', 'Which ocean borders the African continent to the west?', 'Quel océan borde le continent africain à l''ouest ?', '["Southern Ocean", "Atlantic Ocean", "Pacific Ocean", "Arctic Ocean"]'::jsonb, '["Océan Austral", "Océan Atlantique", "Océan Pacifique", "Océan Arctique"]'::jsonb, 1, 'Geography', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-c4b407952bbd462f', 'The equator crosses the African continent almost in the middle.', 'L''équateur traverse le continent africain presque en son milieu.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Geography', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-58048a24c2da25f9', 'The Congo Basin forest is the largest continuous forest massif on the planet.', 'La forêt du bassin du Congo est le plus grand massif forestier continu de la planète.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 1, 'Geography', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-4de4ee376a01d8c6', 'Approximately how many living languages are spoken in Africa?', 'Environ combien de langues vivantes sont parlées sur le continent africain ?', '["5,000", "500", "1,000", "2,000"]'::jsonb, '["5 000", "500", "1 000", "2 000"]'::jsonb, 3, 'Geography', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-179c23209d13e8b6', 'The Bantu expansion, which shaped the current ethnolinguistic map, originated from which current country?', 'L''expansion bantoue, qui explique la carte ethnolinguistique actuelle, a débuté depuis quel pays actuel ?', '["Egypt", "South Africa", "Cameroon", "Nigeria"]'::jsonb, '["Égypte", "Afrique du Sud", "Cameroun", "Nigeria"]'::jsonb, 2, 'Geography', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-0b36c49d93baa0b8', 'Which sea separates Africa from Europe?', 'Quelle mer sépare l''Afrique de l''Europe ?', '["The Indian Ocean", "The Mediterranean Sea", "The Atlantic Ocean", "The Red Sea"]'::jsonb, '["L''océan Indien", "La mer Méditerranée", "L''océan Atlantique", "La mer Rouge"]'::jsonb, 1, 'Geography', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-712d9054f2340017', 'What name did the ancient Greeks give to the African continent?', 'Quel nom les Grecs de l''Antiquité donnaient-ils au continent africain ?', '["Libye", "Ethiopia", "Africa", "Carthage"]'::jsonb, '["Libye", "Éthiopie", "Africa", "Carthage"]'::jsonb, 0, 'Geography', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-0df8353e63643699', 'Africa has a very jagged coastline compared to Europe.', 'Les côtes de l''Afrique sont très découpées, bien plus que celles de l''Europe.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 1, 'Geography', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-b0d13d6fa4835f06', 'In terms of total land area, where does Africa rank among the continents?', 'En termes de superficie, quel est le rang du continent africain ?', '["Third", "Second", "First", "Fourth"]'::jsonb, '["Troisième", "Deuxième", "Premier", "Quatrième"]'::jsonb, 0, 'Geography', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-3d444b8d500bc806', 'Which of these locations has the lowest altitude in Asia?', 'Quel lieu détient le record de l''altitude minimale en Asie ?', '["Dead Sea", "Aral Sea", "Lake Baikal", "Caspian Sea"]'::jsonb, '["La mer Morte", "La mer d''Aral", "Le lac Baïkal", "La mer Caspienne"]'::jsonb, 0, 'Geography', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-34e9316b34002403', 'Asia is defined by a clear and unique physical boundary separating it from Europe.', 'L''Asie est séparée de l''Europe par une frontière physique naturelle indiscutable.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 1, 'Geography', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-60d79649ab4a7396', 'The Baikal Lake contains a significant portion of the planet''s fresh water reserves.', 'Le lac Baïkal contient une part importante des réserves d''eau douce de la planète.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Geography', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-b843de9717efa9c2', 'What is the primary characteristic of Lake Baikal?', 'Quelle est la caractéristique principale du lac Baïkal ?', '["Saltiest water", "Largest surface", "Highest altitude", "Deepest lake"]'::jsonb, '["Le plus salé", "La plus grande surface", "La plus haute altitude", "Le plus profond"]'::jsonb, 3, 'Geography', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-1a38e3ddddf3cc21', 'Which isthmus is traditionally considered the border between Asia and Africa?', 'Quel isthme est traditionnellement considéré comme la frontière entre l''Asie et l''Afrique ?', '["Panama", "Suez", "Kra", "Corinth"]'::jsonb, '["Panama", "Suez", "Kra", "Corinthe"]'::jsonb, 1, 'Geography', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-ed5cfc31a86fcc81', 'Egypt is located on two different continents.', 'L''Égypte est située sur deux continents différents.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Geography', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-7f1faad58768eda0', 'Which explorer divided Oceania into four regions in 1831?', 'Quel explorateur a découpé l''Océanie en quatre régions en 1831 ?', '["James Cook", "Louis Antoine de Bougainville", "Jean-François de La Pérouse", "Jules Dumont d''Urville"]'::jsonb, '["James Cook", "Louis Antoine de Bougainville", "Jean-François de La Pérouse", "Jules Dumont d''Urville"]'::jsonb, 3, 'Geography', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-1a009521a2b2c781', 'The border between Asia and America is located near the Bering Strait.', 'La frontière entre l''Asie et l''Amérique est située aux alentours du détroit de Béring.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Geography', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-7dbf5364595a9d3d', 'Which historical empire covered territory from Singapore to northern Laos?', 'Quel empire historique s''étendait de Singapour au nord du Laos ?', '["Ottoman Empire", "Mughal Empire", "Japanese Empire", "Khmer Empire"]'::jsonb, '["Empire ottoman", "Empire moghol", "Empire japonais", "Empire khmer"]'::jsonb, 3, 'Geography', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-51563fbafb690038', 'Before being colonized by the United States, which European country controlled the Philippines?', 'Avant d''être colonisées par les États-Unis, quel pays européen contrôlait les Philippines ?', '["Portugal", "Spain", "France", "Netherlands"]'::jsonb, '["Portugal", "Espagne", "France", "Pays-Bas"]'::jsonb, 1, 'Geography', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-3fe33864dde59efc', 'Which two languages are the most spoken in South America?', 'Quelles sont les deux langues les plus parlées en Amérique du Sud ?', '["English and Spanish", "Spanish and Italian", "Spanish and Portuguese", "Portuguese and French"]'::jsonb, '["L''anglais et l''espagnol", "L''espagnol et l''italien", "L''espagnol et le portugais", "Le portugais et le français"]'::jsonb, 2, 'Geography', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-d113c249ae639c4e', 'South America was named after which explorer?', 'D''après quel explorateur l''Amérique du Sud a-t-elle été nommée ?', '["Amerigo Vespucci", "Vasco da Gama", "Christopher Columbus", "Ferdinand Magellan"]'::jsonb, '["Amerigo Vespucci", "Vasco de Gama", "Christophe Colomb", "Fernand de Magellan"]'::jsonb, 0, 'Geography', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-43de413be0d95b1d', 'The Amazon is the river with the highest flow in the world.', 'L''Amazone est le fleuve avec le débit le plus important au monde.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Geography', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-c7eaa488f9888e91', 'The country of Panama is geographically part of South America.', 'Le Panama fait géographiquement partie de l''Amérique du Sud.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 1, 'Geography', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-9e4bd4e723d67c52', 'What is the southernmost city in the world, located in South America?', 'Quelle est la ville la plus australe du monde, située en Amérique du Sud ?', '["Ushuaia", "Puerto Toro", "Punta Arenas", "Rio Gallegos"]'::jsonb, '["Ushuaia", "Puerto Toro", "Punta Arenas", "Rio Gallegos"]'::jsonb, 1, 'Geography', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-419e7a4807c02597', 'Which of the following is commonly considered a continent, even if it is technically just a region?', 'Parmi ces régions, laquelle est souvent assimilée à un continent alors qu''elle n''en est pas un au sens strict ?', '["Oceania", "Asia", "Europe", "Africa"]'::jsonb, '["L''Océanie", "L''Asie", "L''Europe", "L''Afrique"]'::jsonb, 0, 'Geography', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-675f7279a0d1d498', 'Which of these is NOT one of the four traditional regions of Oceania?', 'Laquelle de ces régions ne fait pas partie des quatre divisions traditionnelles de l''Océanie ?', '["Australasia", "Polynesia", "Micronesia", "Indonesia"]'::jsonb, '["L''Australasie", "La Polynésie", "La Micronésie", "L''Indonésie"]'::jsonb, 3, 'Geography', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-3310df182a9e3c74', 'The name ''Oceania'' comes from the word ''ocean''.', 'Le nom « Océanie » tire son origine du mot « océan ».', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Geography', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-42af8533bc6fd7fd', 'Which country occupies the vast majority of Oceania''s landmass and population?', 'Quel pays occupe l''essentiel de la surface et de la population de l''Océanie ?', '["Fiji", "Papua New Guinea", "New Zealand", "Australia"]'::jsonb, '["Les Fidji", "La Papouasie-Nouvelle-Guinée", "La Nouvelle-Zélande", "L''Australie"]'::jsonb, 3, 'Geography', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-c9ee1ee7bab7cdaa', 'The border between the ''Extreme-Occident'' and the ''Extreme-Orient'' is located in the middle of New Zealand.', 'La frontière entre l''« extrême-Occident » et l''« extrême-Orient » est située au milieu de la Nouvelle-Zélande.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 1, 'Geography', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-349bd2deca627f49', 'Who is credited with inventing the name ''Oceania'' for his 1814 map?', 'Quel cartographe a inventé le nom « Océanie » sur sa carte publiée en 1814 ?', '["Conrad Malte-Brun", "Charles de Brosses", "Edme Mentelle", "Adrien-Hubert Brué"]'::jsonb, '["Conrad Malte-Brun", "Charles de Brosses", "Edme Mentelle", "Adrien-Hubert Brué"]'::jsonb, 3, 'Geography', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-fc0a0f96efdbef44', 'The division of Oceania into Melanesia, Micronesia, and Polynesia was established by a French explorer.', 'Le découpage de l''Océanie en Mélanésie, Micronésie et Polynésie a été établi par un explorateur français.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Geography', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-6467df1897de9f82', 'Which iconic Australian tree is known for its adaptation to arid climates and fire?', 'Quel arbre emblématique d''Australie est connu pour ses adaptations à l''aridité et au feu ?', '["Maple", "Oak", "Pine", "Eucalyptus"]'::jsonb, '["Érable", "Chêne", "Pin", "Eucalyptus"]'::jsonb, 3, 'Geography', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-36676fbce7fdf403', 'The vast desert or semi-arid region covering most of Australia is called the outback.', 'La vaste zone désertique ou semi-aride qui couvre la majeure partie de l''Australie est appelée l''outback.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Geography', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-48e02e259b99d36a', 'What distinguishes ''Near Oceania'' from ''Remote Oceania'' in geographical studies?', 'Qu''est-ce qui distingue l''Océanie proche de l''Océanie lointaine dans les études géographiques ?', '["Language families", "Annual rainfall", "Navigation distance", "Political status"]'::jsonb, '["Les familles linguistiques", "La pluviométrie annuelle", "La distance de navigation", "Le statut politique"]'::jsonb, 2, 'Geography', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-f88400900bc1e052', 'New Zealand is considered part of the ''insular Pacific'' grouping alongside the smaller Pacific islands.', 'La Nouvelle-Zélande est considérée comme faisant partie du Pacifique insulaire au même titre que les petites îles du Pacifique.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 1, 'Geography', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-b9f5ce0bf11ffed2', 'Which nickname is commonly given to Japan?', 'Quel surnom est couramment donné au Japon ?', '["The Land of the Morning Calm", "The Land of the Rising Sun", "The Land of the Thousand Islands", "The Land of the Dragon"]'::jsonb, '["Le pays du matin calme", "Le pays du soleil levant", "Le pays des mille îles", "Le pays du dragon"]'::jsonb, 1, 'Geography', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-e986df2d83b417e0', 'Which of these is NOT one of the four main islands of Japan?', 'Laquelle de ces îles n''est PAS l''une des quatre îles principales du Japon ?', '["Honshu", "Okinawa", "Shikoku", "Hokkaido"]'::jsonb, '["Honshu", "Okinawa", "Shikoku", "Hokkaido"]'::jsonb, 1, 'Geography', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-b92cf13cdc3e28a2', 'Japan is currently the most populous country in the world.', 'Le Japon est actuellement le pays le plus peuplé du monde.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 1, 'Geography', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-e071d520265b6067', 'Japan is among the world''s leading economic powers by nominal GDP.', 'Le Japon fait partie des premières puissances économiques mondiales selon le PIB nominal.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Geography', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-c9a1ab86adc512db', 'Before using the name Nihon or Nippon, how did the Japanese refer to their country?', 'Avant d''utiliser le nom Nihon ou Nippon, comment les Japonais désignaient-ils leur pays ?', '["Nara", "Kyoto", "Shinto", "Yamato"]'::jsonb, '["Nara", "Kyoto", "Shinto", "Yamato"]'::jsonb, 3, 'Geography', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-bf86f62cd8f857f1', 'Which of these terms is commonly used on Japanese banknotes and stamps?', 'Lequel de ces termes est couramment utilisé sur les billets de banque et les timbres japonais ?', '["Hōjin", "Yamato", "Nihonjin", "Nippon"]'::jsonb, '["Hōjin", "Yamato", "Nihonjin", "Nippon"]'::jsonb, 3, 'Geography', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-4a655a6b9c8ea94b', 'Which name did explorer Marco Polo use to refer to Japan?', 'Quel nom l''explorateur Marco Polo utilisait-il pour désigner le Japon ?', '["Cipangu", "Yamato", "Nippon", "Edo"]'::jsonb, '["Cipangu", "Yamato", "Nippon", "Edo"]'::jsonb, 0, 'Geography', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-59c21ee6cde8897b', 'The Ainu people are considered the first inhabitants of the Japanese archipelago.', 'Le peuple Aïnou est considéré comme le premier habitant de l''archipel japonais.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Geography', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-ff16847f8da11931', 'The term ''Hōjin'' is used to describe foreign tourists visiting Japan.', 'Le terme « Hōjin » est utilisé pour désigner les touristes étrangers en visite au Japon.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 1, 'Geography', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-aa232ee52b4ab4d9', 'What was the title of the military leaders who held real power in Japan from 1192?', 'Quel était le titre des chefs militaires qui détenaient le véritable pouvoir au Japon à partir de 1192 ?', '["Shoguns", "Samurai", "Gokenin", "Daimyo"]'::jsonb, '["Shoguns", "Samouraïs", "Gokenin", "Daimyo"]'::jsonb, 0, 'Geography', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-88b6549d69cca133', 'Which of these historical figures is known as one of the three ''unifiers of Japan''?', 'Lequel de ces personnages historiques est connu comme l''un des trois « unificateurs du Japon » ?', '["Jinmu", "Ninigi", "Tokugawa Ieyasu", "Fujiwara"]'::jsonb, '["Jinmu", "Ninigi", "Tokugawa Ieyasu", "Fujiwara"]'::jsonb, 2, 'Geography', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-cac6bc7b600b6eda', 'What does the word ''kanata'', the origin of the name Canada, mean in Iroquoian?', 'Que signifie le mot iroquois « kanata », à l''origine du nom Canada ?', '["Great river", "Village", "Cold land", "Mountain"]'::jsonb, '["Grand fleuve", "Village", "Terre froide", "Montagne"]'::jsonb, 1, 'Geography', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-7d78f1c53f89e2d3', 'Canada has two official languages: English and French.', 'Le Canada possède deux langues officielles : l''anglais et le français.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Geography', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-fa536819d671f46a', 'Canada borders three oceans. Which one is NOT one of them?', 'Le Canada est bordé par trois océans. Lequel n''en fait PAS partie ?', '["Arctic Ocean", "Atlantic Ocean", "Indian Ocean", "Pacific Ocean"]'::jsonb, '["Océan Arctique", "Océan Atlantique", "Océan Indien", "Océan Pacifique"]'::jsonb, 2, 'Geography', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-92040e92f14cf81f', 'The Prime Minister of Canada is the official Head of State.', 'Le Premier ministre du Canada est le chef officiel de l''État.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 1, 'Geography', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-940217e782828256', 'Which explorer brought two indigenous guides back to France in 1534?', 'Quel explorateur a ramené deux guides autochtones en France en 1534 ?', '["Samuel de Champlain", "Jacques Cartier", "Amerigo Vespucci", "Christopher Columbus"]'::jsonb, '["Samuel de Champlain", "Jacques Cartier", "Amerigo Vespucci", "Christophe Colomb"]'::jsonb, 1, 'Geography', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-17eae75356d7a093', 'Jacques Cartier discovered that Anticosti was an island thanks to his guides.', 'Jacques Cartier a découvert qu''Anticosti était une île grâce à ses guides.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Geography', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-5db4fce585cea7db', 'Jacques Cartier used the word ''Canada'' only once in his entire travel journal.', 'Jacques Cartier a utilisé le mot « Canada » une seule fois dans tout son journal de voyage.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 1, 'Geography', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-f18b0028e19c1b1f', 'Which city''s cartography school was instrumental in spreading the name ''Canada'' across Europe?', 'Quelle école de cartographie a contribué à diffuser le nom « Canada » à travers l''Europe ?', '["Bordeaux", "Saint-Malo", "Dieppe", "Paris"]'::jsonb, '["Bordeaux", "Saint-Malo", "Dieppe", "Paris"]'::jsonb, 2, 'Geography', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-3250e0fd8781c000', 'What landmark did Cartier reach in 1535 that he identified as the start of the ''province of Canada''?', 'Quel lieu Cartier a-t-il atteint en 1535, le qualifiant de début de la « province de Canada » ?', '["Anticosti Island", "Orleans Island", "The Gaspé Peninsula", "Montreal Island"]'::jsonb, '["L''île d''Anticosti", "L''île d''Orléans", "La péninsule gaspésienne", "L''île de Montréal"]'::jsonb, 1, 'Geography', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-a3a47a4f50e7b03d', 'Brazil occupies about half of the total area of South America.', 'Le Brésil occupe environ la moitié de la superficie de l''Amérique du Sud.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Geography', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-d0ec3bfb992fb8dd', 'Which colors are prominently featured on the Brazilian flag?', 'Quelles sont les couleurs dominantes sur le drapeau du Brésil ?', '["Blue and white", "Red and white", "Green and yellow", "Blue and yellow"]'::jsonb, '["Bleu et blanc", "Rouge et blanc", "Vert et jaune", "Bleu et jaune"]'::jsonb, 2, 'Geography', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-e283b797615d08db', 'What does the name ''Brazil'' originally refer to?', 'À quoi fait référence l''origine du nom « Brésil » ?', '["A specific mountain range", "A local indigenous tribe", "A type of red dye wood", "The color of the tropical sun"]'::jsonb, '["Une chaîne de montagnes", "Une tribu indigène locale", "Un bois produisant une teinture rouge", "La couleur du soleil tropical"]'::jsonb, 2, 'Geography', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-80f989c4143fe7a6', 'What do the 27 stars on the Brazilian flag represent?', 'Que représentent les 27 étoiles présentes sur le drapeau du Brésil ?', '["The 27 major cities", "The 27 original provinces", "The 27 indigenous tribes", "The 26 states and the capital"]'::jsonb, '["Les 27 villes principales", "Les 27 provinces originales", "Les 27 tribus indigènes", "Les 26 États et la capitale"]'::jsonb, 3, 'Geography', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-2ce34ee4114a44d5', 'What was the name of the short-lived French colony in Rio de Janeiro in the 16th century?', 'Quel était le nom de l''éphémère colonie française installée à Rio de Janeiro au XVIe siècle ?', '["Nouvelle-France", "France australe", "France équinoxiale", "France Antarctique"]'::jsonb, '["Nouvelle-France", "France australe", "France équinoxiale", "France antarctique"]'::jsonb, 3, 'Geography', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-033643e6dec0dd1e', 'Pedro Álvares Cabral is the explorer who discovered the Brazilian coast in 1500.', 'Pedro Álvares Cabral est l''explorateur qui a découvert les côtes brésiliennes en 1500.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Geography', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-3e8f0d461810ec94', 'The oldest pottery ever discovered in the Western Hemisphere was found in the Amazon basin.', 'La plus ancienne poterie jamais découverte dans l''hémisphère occidental a été trouvée dans le bassin amazonien.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Geography', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-bfb702bb4653e32b', 'The Tupi tribe originally settled only in the Amazonian rainforest.', 'La tribu des Tupis s''est installée uniquement dans la forêt amazonienne.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 1, 'Geography', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-a1399b313efdadc6', 'Which two large islands are part of the Italian territory?', 'Quelles sont les deux grandes îles qui font partie du territoire italien ?', '["Capri and Ischia", "Corsica and Elba", "Malta and Cyprus", "Sicily and Sardinia"]'::jsonb, '["Capri et Ischia", "La Corse et l''île d''Elbe", "Malte et Chypre", "La Sicile et la Sardaigne"]'::jsonb, 3, 'Geography', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-b13f42c3310687b2', 'Which of these countries does NOT share a land border with Italy?', 'Lequel de ces pays ne possède PAS de frontière terrestre avec l''Italie ?', '["France", "Austria", "Switzerland", "Germany"]'::jsonb, '["La France", "L''Autriche", "La Suisse", "L''Allemagne"]'::jsonb, 3, 'Geography', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-9b5f6b91756933a4', 'Italy has been a parliamentary republic since 1946.', 'L''Italie est une république parlementaire depuis 1946.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Geography', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-d7fe4d1dc68f40d7', 'According to Greek mythology, from whom does the name ''Italia'' originate?', 'Selon la mythologie grecque, de qui le nom « Italia » tire-t-il son origine ?', '["Italos", "Hercules", "Telegonos", "Geryon"]'::jsonb, '["Italos", "Héraclès", "Telegonos", "Géryon"]'::jsonb, 0, 'Geography', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-661fbc1970d3236f', 'Which mountain range connects Italy to the rest of the European continent?', 'Quel massif montagneux rattache l''Italie au reste du continent européen ?', '["The Pyrenees", "The Alps", "The Apennines", "The Dolomites"]'::jsonb, '["Les Pyrénées", "Les Alpes", "Les Apennins", "Les Dolomites"]'::jsonb, 1, 'Geography', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-ddfb6cc379c7f0f4', 'According to legend, which two brothers founded Rome?', 'Selon la légende, quels sont les deux frères fondateurs de Rome ?', '["Castor and Pollux", "Romulus and Remus", "Tiberius and Gaius", "Caesar and Augustus"]'::jsonb, '["Castor et Pollux", "Romulus et Rémus", "Tibère et Caius", "César et Auguste"]'::jsonb, 1, 'Geography', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-e8386e9bb0b02595', 'Which non-Indo-European civilization lived in Italy before the rise of Rome?', 'Quelle civilisation non-indo-européenne vivait en Italie avant l''essor de Rome ?', '["Samnite", "Greek", "Etruscan", "Celtic"]'::jsonb, '["Samnite", "Grecque", "Étrusque", "Celtique"]'::jsonb, 2, 'Geography', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-0353ac8dcb408308', 'In 31 BC, Octave defeated the fleet of Mark Antony and Cleopatra at which battle?', 'En 31 av. J.-C., Octave a vaincu la flotte de Marc Antoine et Cléopâtre lors de quelle bataille ?', '["Philippi", "Cannae", "Zama", "Actium"]'::jsonb, '["Philippes", "Cannes", "Zama", "Actium"]'::jsonb, 3, 'Geography', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-4824428d4b3f4e05', 'Rome fought the Punic Wars against the civilization of Carthage.', 'Rome a mené les guerres puniques contre la civilisation de Carthage.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Geography', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-b045d11e047534dd', 'Rome granted citizenship to all Italians as early as 89 BC.', 'Rome a accordé la citoyenneté à l''ensemble des Italiens dès 89 av. J.-C.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Geography', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-529e183eb07d071e', 'Jules César died in the 1st century AD.', 'Jules César est mort au Ier siècle après J.-C.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 1, 'Geography', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-9a480b4919c99b66', 'Which country is the largest state on the planet by land area?', 'Quel est le pays le plus vaste de la planète ?', '["Canada", "China", "United States", "Russia"]'::jsonb, '["Le Canada", "La Chine", "Les États-Unis", "La Russie"]'::jsonb, 3, 'Geography', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-ba7e075f88f40972', 'Russia is located entirely within the continent of Europe.', 'La Russie est située entièrement sur le continent européen.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 1, 'Geography', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-0469b440fa1df150', 'Which historical figure founded the Tsardom of Russia in 1547?', 'Quel personnage historique a fondé le tsarat de Russie en 1547 ?', '["Boris Yeltsin", "Peter the Great", "Vladimir Lenin", "Ivan the Terrible"]'::jsonb, '["Boris Eltsine", "Pierre le Grand", "Vladimir Lénine", "Ivan le Terrible"]'::jsonb, 3, 'Geography', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-980136d1881b0c33', 'What type of forest primarily covers the majority of Russian territory?', 'Quel type de forêt recouvre la majorité du territoire russe ?', '["Taiga", "Mangrove", "Tropical rainforest", "Temperate deciduous forest"]'::jsonb, '["Taïga", "Mangrove", "Forêt tropicale", "Forêt tempérée"]'::jsonb, 0, 'Geography', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-8262e3015beef140', 'What is the highest peak in Europe?', 'Quel est le sommet le plus élevé d''Europe ?', '["Mont Blanc", "Mount Everest", "Mount Belukha", "Mount Elbrus"]'::jsonb, '["Le mont Blanc", "L''Everest", "Le mont Beloukha", "Le mont Elbrouz"]'::jsonb, 3, 'Geography', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-505b6b6c6f8e7c8d', 'What mountain range separates European Russia from Asian Russia?', 'Quel massif montagneux sépare la Russie d''Europe de la Russie d''Asie ?', '["The Verkhoyansk Range", "The Altai Mountains", "The Caucasus", "The Ural Mountains"]'::jsonb, '["Les monts de Verkhoïansk", "L''Altaï", "Le Caucase", "L''Oural"]'::jsonb, 3, 'Geography', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-7d59e902ad249f0b', 'In Russia, there are traditionally four distinct seasons of equal length.', 'En Russie, il existe traditionnellement quatre saisons de durée équivalente.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 1, 'Geography', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-7ccd15b333da25a6', 'Russia''s forest cover represents what fraction of the world''s total forests?', 'La forêt russe représente quelle fraction de l''ensemble des forêts de la planète ?', '["One half", "One tenth", "One third", "One fifth"]'::jsonb, '["La moitié", "Un dixième", "Un tiers", "Un cinquième"]'::jsonb, 3, 'Geography', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-287f233778cabe71', 'The Chinese Communist Party has been governing China since 1949.', 'Le Parti communiste chinois gouverne la Chine depuis 1949.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Geography', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-f76dd1bfa71a0bc7', 'What nickname is sometimes used to refer to China?', 'Quel surnom est parfois utilisé pour désigner la Chine ?', '["Dragon Land", "Middle Kingdom", "Celestial Empire", "Land of the Rising Sun"]'::jsonb, '["Terre du Dragon", "Empire du Milieu", "Empire céleste", "Pays du Soleil-Levant"]'::jsonb, 1, 'Geography', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-696acd5e7c6780fc', 'Which dynasty is considered to have given its name to China?', 'Quelle dynastie a donné son nom à la Chine ?', '["Han", "Qin", "Tang", "Ming"]'::jsonb, '["Han", "Qin", "Tang", "Ming"]'::jsonb, 1, 'Geography', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-decf88ef53bc59cb', 'Rice cultivation in China dates back to the Neolithic period.', 'La culture du riz en Chine remonte à l''époque du Néolithique.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Geography', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-84e90794fd05592e', 'What does the Japanese term ''kamikaze'' originally mean?', 'Que signifie littéralement le terme japonais « kamikaze » ?', '["Imperial storm", "Wind of the gods", "Divine sword", "Sacred mountain"]'::jsonb, '["Tempête impériale", "Vent des dieux", "Épée divine", "Montagne sacrée"]'::jsonb, 1, 'Geography', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-f8694eca340743bc', 'The famous terracotta army was discovered in the 19th century.', 'La célèbre armée enterrée a été découverte au XIXe siècle.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 1, 'Geography', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-6da914098d087f5b', 'In ancient Chinese texts, what name was used to refer to the Roman Empire?', 'Dans les anciens textes chinois, quel nom était utilisé pour désigner l''Empire romain ?', '["Da Qin", "Yuan", "Xia", "Han"]'::jsonb, '["Da Qin", "Yuan", "Xia", "Han"]'::jsonb, 0, 'Geography', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-37c39ca04bb71538', 'Who was the famous admiral who led China''s ''Great Fleet'' expeditions in the 15th century?', 'Quel célèbre amiral a dirigé les expéditions de la « Grande Flotte » chinoise au XVe siècle ?', '["Kubilai Khan", "Zheng He", "Sun Yat-sen", "Qin Shi Huang"]'::jsonb, '["Kubilai Khan", "Zheng He", "Sun Yat-sen", "Qin Shi Huang"]'::jsonb, 1, 'Geography', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-72e997ceec570eb7', 'What is the literal meaning of the name ''Iceland''?', 'Que signifie littéralement le nom ''Islande'' ?', '["Land of fire", "Land of volcanoes", "Land of ice", "Land of mist"]'::jsonb, '["Pays du feu", "Pays des volcans", "Pays de glace", "Pays de la brume"]'::jsonb, 2, 'Geography', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-010f5b9a3393da3d', 'Iceland is home to one of the oldest parliaments in the world, the Althing.', 'L''Islande abrite l''un des plus vieux parlements au monde, l''Althing.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Geography', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-10aae69abe6800eb', 'Iceland''s volcanic activity is due to its location on the Mid-Atlantic Ridge.', 'L''activité volcanique de l''Islande est due à sa position sur la dorsale médio-atlantique.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Geography', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-ffb682220ba9f0a4', 'Which current helps keep Iceland''s climate temperate despite its high latitude?', 'Quel courant marin contribue à tempérer le climat de l''Islande malgré sa latitude ?', '["Canary Current", "Labrador Current", "North Atlantic Drift", "Gulf Stream"]'::jsonb, '["Courant des Canaries", "Courant du Labrador", "Dérive nord-atlantique", "Gulf Stream"]'::jsonb, 3, 'Geography', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-969d6caaa5c043e5', 'Iceland is currently a member state of the European Union.', 'L''Islande est actuellement un État membre de l''Union européenne.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 1, 'Geography', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-b66110ccd882282f', 'Approximately how many active volcanoes are there on the island of Iceland?', 'Environ combien de volcans actifs compte l''Islande ?', '["130", "30", "250", "500"]'::jsonb, '["130", "30", "250", "500"]'::jsonb, 0, 'Geography', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-6d7ddd8cfe9bd1f1', 'Iceland shares a land border with Greenland.', 'L''Islande possède une frontière terrestre avec le Groenland.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 1, 'Geography', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-2c92d6bcfda11f3f', 'Which two tectonic plates meet in Iceland?', 'Quelles sont les deux plaques tectoniques qui se rejoignent en Islande ?', '["African and American", "Eurasian and African", "American and Eurasian", "Pacific and American"]'::jsonb, '["Africaine et américaine", "Eurasiatique et africaine", "Américaine et eurasiatique", "Pacifique et américaine"]'::jsonb, 2, 'Geography', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-0c627bd6055c9024', 'The Arctic Circle crosses the main island of Iceland.', 'Le cercle polaire arctique traverse l''île principale de l''Islande.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 1, 'Geography', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-5d50cc30d65a784c', 'From which language does the word ''geyser'' originate?', 'De quelle langue provient le mot « geyser » ?', '["Swedish", "Danish", "Icelandic", "Norwegian"]'::jsonb, '["Suédois", "Danois", "Islandais", "Norvégien"]'::jsonb, 2, 'Geography', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-d4dcc48fb5a6eec3', 'What ocean current keeps the Icelandic coast relatively mild in winter?', 'Quel courant océanique permet aux côtes islandaises de rester relativement douces en hiver ?', '["Labrador Current", "Gulf Stream", "Canary Current", "North Atlantic Drift"]'::jsonb, '["Courant du Labrador", "Gulf Stream", "Courant des Canaries", "Dérive nord-atlantique"]'::jsonb, 1, 'Geography', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-979cbefdaa4fd01e', 'What percentage of Antarctica''s surface is covered by ice?', 'Quel pourcentage de la surface de l''Antarctique est recouvert de glace ?', '["85%", "92%", "75%", "98%"]'::jsonb, '["85 %", "92 %", "75 %", "98 %"]'::jsonb, 3, 'Geography', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-27ea980d2450ca1b', 'Antarctica has a permanent native population.', 'L''Antarctique possède une population autochtone permanente.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 1, 'Geography', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-031880a79fd01789', 'Which continent was officially discovered in the 19th century by William Smith?', 'Quel continent a été officiellement découvert au XIXe siècle par William Smith ?', '["South America", "Antarctica", "Australia", "Africa"]'::jsonb, '["L''Amérique du Sud", "L''Antarctique", "L''Australie", "L''Afrique"]'::jsonb, 1, 'Geography', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-1ff509a0cdbff5c8', 'James Cook was the first explorer to cross the Antarctic Circle.', 'James Cook est le premier explorateur à avoir franchi le cercle polaire.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Geography', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-5026f9544d65b751', 'Which famous explorer gave his name to the strait located at the southern tip of South America?', 'Quel célèbre explorateur a donné son nom au détroit situé à la pointe sud de l''Amérique du Sud ?', '["Francis Drake", "James Cook", "Fernand de Magellan", "William Smith"]'::jsonb, '["Francis Drake", "James Cook", "Fernand de Magellan", "William Smith"]'::jsonb, 2, 'Geography', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-2f57591338bb9883', 'Jean-Baptiste Charles Bouvet de Lozier discovered a continent that was actually an island.', 'Jean-Baptiste Charles Bouvet de Lozier a découvert un continent qui était en réalité une île.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Geography', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-41efbd46c72971f6', 'Which explorer discovered the islands that now bear his name in 1772?', 'Quel explorateur a découvert les îles qui portent aujourd''hui son nom en 1772 ?', '["Marion du Fresne", "Le Maire", "Bouvet", "Kerguelen"]'::jsonb, '["Marion du Fresne", "Le Maire", "Bouvet", "Kerguelen"]'::jsonb, 3, 'Geography', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-ccee35e7742bde94', 'Which city was the starting point for Francis Drake''s expedition in 1577?', 'Quelle ville fut le point de départ de l''expédition de Francis Drake en 1577 ?', '["Liverpool", "London", "Plymouth", "Southampton"]'::jsonb, '["Liverpool", "Londres", "Plymouth", "Southampton"]'::jsonb, 2, 'Geography', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-b40a240fd9645218', 'Which mountain is the highest peak in the Alps, reaching 4,806 meters?', 'Quel sommet est le point culminant des Alpes, atteignant 4 806 mètres ?', '["Eiger", "Monte Rosa", "Mont Blanc", "Matterhorn"]'::jsonb, '["Eiger", "Mont Rose", "Mont Blanc", "Cervin"]'::jsonb, 2, 'Geography', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-c1c2f0b8b64d321c', 'Monaco is one of the countries covered by the Alps.', 'Monaco est l''un des pays recouverts par les Alpes.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Geography', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-e2211de4ed973ed5', 'Which country holds the largest share of the Alps'' total surface area?', 'Quel pays possède la plus grande part de la surface totale des Alpes ?', '["Switzerland", "France", "Austria", "Italy"]'::jsonb, '["Suisse", "France", "Autriche", "Italie"]'::jsonb, 2, 'Geography', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-a348e74283d5c7e7', 'The name ''Alps'' is believed to originate from a root meaning ''black''.', 'Le nom « Alpes » aurait pour origine une racine signifiant « noir ».', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 1, 'Geography', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-83669a1be9f361b7', 'Which of these is NOT one of the three main subdivisions of the Alps?', 'Laquelle de ces zones n''est PAS une des trois grandes subdivisions des Alpes ?', '["Northern Alps", "Western Alps", "Eastern Alps", "Central Alps"]'::jsonb, '["Alpes du Nord", "Alpes occidentales", "Alpes orientales", "Alpes centrales"]'::jsonb, 0, 'Geography', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-b02709823b560b77', 'Which city is considered the capital of the Alps in France?', 'Quelle ville est considérée comme la capitale des Alpes en France ?', '["Grenoble", "Gap", "Annecy", "Chamonix"]'::jsonb, '["Grenoble", "Gap", "Annecy", "Chamonix"]'::jsonb, 0, 'Geography', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-263ad8be7fdbc168', 'Which famous winds are formed by the interaction between Alpine depressions and anticyclones?', 'Quels vents célèbres sont formés par l''interaction entre les dépressions et les anticyclones dans les Alpes ?', '["Foehn and Sirocco", "Bise and Autan", "Marin and Levant", "Mistral and Tramontane"]'::jsonb, '["Le foehn et le sirocco", "La bise et l''autan", "Le marin et le levant", "Le mistral et la tramontane"]'::jsonb, 3, 'Geography', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-8f694d0804b19c56', 'The upper tree line in the Alps is generally located below 1,000 meters.', 'La limite supérieure des forêts dans les Alpes se situe généralement en dessous de 1 000 mètres.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 1, 'Geography', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-eae39665e56e81a7', 'Which country hosts the largest share of the Alpine population?', 'Quel pays abrite la plus grande part de la population alpine ?', '["France", "Austria", "Italy", "Switzerland"]'::jsonb, '["La France", "L''Autriche", "L''Italie", "La Suisse"]'::jsonb, 2, 'Geography', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-0a38bfc4a369371d', 'Human settlement in the Alps dates back to which period?', 'Le peuplement des Alpes par l''homme remonte à quelle période ?', '["Iron Age", "Neolithic", "Middle Paleolithic", "Bronze Age"]'::jsonb, '["L''âge du fer", "Le Néolithique", "Le Paléolithique moyen", "L''âge du bronze"]'::jsonb, 2, 'Geography', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-39e6d1b916c8e412', 'What type of sea is the Mediterranean?', 'Quel type de mer est la Méditerranée ?', '["A freshwater sea", "A tropical sea", "An open ocean", "A semi-enclosed sea"]'::jsonb, '["Une mer d''eau douce", "Une mer tropicale", "Un océan ouvert", "Une mer semi-fermée"]'::jsonb, 3, 'Geography', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-bb09aebce5ed10bd', 'Which material is nicknamed the ''red gold of the Mediterranean''?', 'Quel matériau est surnommé « l''or rouge de la Méditerranée » ?', '["Red sand", "Red clay", "Red coral", "Red algae"]'::jsonb, '["Le sable rouge", "L''argile rouge", "Le corail rouge", "L''algue rouge"]'::jsonb, 2, 'Geography', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-f6ddd10589b7ebfa', 'Julius Caesar called the Mediterranean ''Mare nostrum''.', 'Jules César appelait la Méditerranée « Mare nostrum ».', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Geography', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-8128f42cbc2cc7c3', 'Ancient Greeks nicknamed the Mediterranean ''the sea beyond the Pillars of Hercules''.', 'Les Grecs anciens surnommaient la Méditerranée « la mer au-delà des Colonnes d''Hercule ».', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 1, 'Geography', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-09aaa047a29e1ebf', 'Which plant species is protected in the Mediterranean for its role in the ecosystem?', 'Quelle espèce végétale est protégée en Méditerranée pour son rôle dans l''écosystème ?', '["Sea kelp", "Blue lotus", "Posidonia oceanica", "Coral weed"]'::jsonb, '["Le varech", "Le lotus bleu", "La posidonie", "L''herbe de corail"]'::jsonb, 2, 'Geography', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-bd3f22d93f8d3720', 'Which empire was the only one in history to unify the entire Mediterranean basin?', 'Quel empire fut le seul de l''histoire à unifier l''intégralité du bassin méditerranéen ?', '["Roman Empire", "Byzantine Empire", "Ottoman Empire", "Egyptian Empire"]'::jsonb, '["Empire romain", "Empire byzantin", "Empire ottoman", "Empire égyptien"]'::jsonb, 0, 'Geography', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-82564370e5e6fe2d', 'Which 19th-century infrastructure project boosted trade in the Mediterranean by connecting it to Asia?', 'Quel aménagement du XIXe siècle a redynamisé le commerce en Méditerranée en facilitant l''accès vers l''Asie ?', '["Panama Canal", "Bosporus Strait", "Suez Canal", "Gibraltar Strait"]'::jsonb, '["Canal de Panama", "Détroit du Bosphore", "Canal de Suez", "Détroit de Gibraltar"]'::jsonb, 2, 'Geography', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-ae84634d5e281825', 'The Mediterranean Sea is divided into two distinct basins separated by shallow waters between Sicily and Tunisia.', 'La mer Méditerranée est divisée en deux bassins distincts séparés par des hauts fonds entre la Sicile et la Tunisie.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Geography', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-767fe9943ae90868', 'Roughly, how much larger is the eastern Mediterranean basin compared to the western one?', 'Environ combien de fois le bassin oriental méditerranéen est-il plus grand que le bassin occidental ?', '["Half the size", "The same size", "Almost double", "Three times larger"]'::jsonb, '["La moitié", "La même taille", "Presque le double", "Trois fois plus grand"]'::jsonb, 2, 'Geography', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-f19583a03e3cc45a', 'The Mediterranean Sea is located at the boundary between the African and American tectonic plates.', 'La mer Méditerranée se situe à la limite entre les plaques tectoniques africaine et américaine.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 1, 'Geography', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-d0b454a8e67a298e', 'Which two rivers meet to form the Nile?', 'Quels sont les deux cours d''eau qui se rejoignent pour former le Nil ?', '["The Red Nile and the Black Nile", "The Great Nile and the Little Nile", "The White Nile and the Blue Nile", "The Green Nile and the Yellow Nile"]'::jsonb, '["Le Nil Rouge et le Nil Noir", "Le Grand Nil et le Petit Nil", "Le Nil Blanc et le Nil Bleu", "Le Nil Vert et le Nil Jaune"]'::jsonb, 2, 'Geography', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-f92c049b1cb50549', 'In which city do the White and Blue Nile meet?', 'Dans quelle ville se rejoignent le Nil Blanc et le Nil Bleu ?', '["Khartoum", "Cairo", "Alexandria", "Addis Ababa"]'::jsonb, '["Khartoum", "Le Caire", "Alexandrie", "Addis-Abeba"]'::jsonb, 0, 'Geography', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-7fb79e3207a9283c', 'In ancient times, Egypt was called ''Kemet'', which means ''the red land''.', 'Dans l''Antiquité, l''Égypte était appelée « Kemet », ce qui signifie « la terre rouge ».', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 1, 'Geography', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-bda64a0e0afe818a', 'From which lake does the Blue Nile originate?', 'De quel lac le Nil Bleu prend-il sa source ?', '["Lake Victoria", "Lake Tana", "Lake Nasser", "Lake Albert"]'::jsonb, '["Le lac Victoria", "Le lac Tana", "Le lac Nasser", "Le lac Albert"]'::jsonb, 1, 'Geography', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-5fa8bfef28a33912', 'Into which sea does the Nile flow after passing through Cairo?', 'Dans quelle mer le Nil se jette-t-il après avoir traversé le Caire ?', '["The Caspian Sea", "The Black Sea", "The Mediterranean Sea", "The Red Sea"]'::jsonb, '["La mer Caspienne", "La mer Noire", "La mer Méditerranée", "La mer Rouge"]'::jsonb, 2, 'Geography', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-9acb5758374a27e2', 'Which of these rivers is NOT a main tributary of the Nile?', 'Parmi ceux-ci, lequel n''est PAS un affluent principal du Nil ?', '["The Blue Nile", "The White Nile", "The Atbara", "The Amazon"]'::jsonb, '["Le Nil Bleu", "Le Nil Blanc", "L''Atbara", "L''Amazone"]'::jsonb, 3, 'Geography', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-e28cebfabe5b6f46', 'What geological feature does the Nile form in Sudan?', 'Quelle particularité géographique le Nil présente-t-il au Soudan ?', '["Glaciers", "Fjords", "Geysers", "Cataracts"]'::jsonb, '["Des glaciers", "Des fjords", "Des geysers", "Des cataractes"]'::jsonb, 3, 'Geography', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-8f2de2131ce578ef', 'In Ancient Egypt, the majority of the population lived along the banks of the Nile.', 'Dans l''Égypte antique, la majorité de la population vivait sur les rives du Nil.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Geography', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-1bcb6b0ea97c6ac1', 'The flow of the Nile increases significantly as it crosses the Sahara Desert.', 'Le débit du Nil augmente considérablement lors de sa traversée du désert du Sahara.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 1, 'Geography', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-4b00bfdb2a52cfc2', 'France is considered a transcontinental state.', 'La France est considérée comme un État transcontinental.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Geography', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-1b7d0c100af7a893', 'The total length of France''s land borders is longer in metropolitan France than in its overseas territories.', 'Le linéaire total des frontières terrestres de la France est plus long en métropole qu''en outre-mer.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Geography', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-e2cb3eafa100f5e0', 'Which of these is the largest ancient mountain range in France?', 'Quel est le plus vaste ensemble de massifs anciens en France ?', '["Vosges", "Massif Armoricain", "Ardenne", "Massif Central"]'::jsonb, '["Vosges", "Massif armoricain", "Ardenne", "Massif central"]'::jsonb, 3, 'Geography', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-1ae3c2e7cad997e9', 'In the French Alps, what is the approximate height threshold exceeded by many peaks?', 'Dans les Alpes françaises, quel seuil d''altitude est dépassé par de nombreux sommets ?', '["4 000 meters", "5 000 meters", "2 000 meters", "3 000 meters"]'::jsonb, '["4 000 mètres", "5 000 mètres", "2 000 mètres", "3 000 mètres"]'::jsonb, 3, 'Geography', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-52e9a14f1787c0e1', 'The Jura mountains are primarily composed of ancient volcanic rock.', 'Le massif du Jura est principalement constitué de roches volcaniques anciennes.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 1, 'Geography', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-069ce8be9ae87421', 'The Soufrière volcano in Guadeloupe stands at an altitude of 1 467 meters.', 'Le volcan de la Soufrière en Guadeloupe culmine à 1 467 mètres d''altitude.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Geography', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-e3b3fb8d5947f73d', 'Which historical figure is traditionally credited with setting the eastern border of Europe at the Ural Mountains?', 'Quel personnage historique a traditionnellement fixé la limite est de l''Europe aux monts Oural ?', '["Charlemagne", "Peter the Great", "Charles V", "Napoleon I"]'::jsonb, '["Charlemagne", "Pierre le Grand", "Charles Quint", "Napoléon Ier"]'::jsonb, 1, 'Geography', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-5f1f689c230a8703', 'Which people began spreading across most of Europe around 1,200 BC, from the Carpathian Basin to eastern France?', 'Quel peuple a commencé à s''étendre sur la majeure partie de l''Europe à partir de 1 200 av. J.-C. ?', '["The Celts", "The Slavs", "The Germanic peoples", "The Romans"]'::jsonb, '["Les Celtes", "Les Slaves", "Les peuples germains", "Les Romains"]'::jsonb, 0, 'Geography', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-aa0570cf4d1ede73', 'Which famous fortification marked the northern boundary of the Roman Empire in Europe?', 'Quelle célèbre fortification marquait la limite nord de l''Empire romain en Europe ?', '["The Alps", "Hadrian''s Wall", "The Danube", "The Rhine"]'::jsonb, '["Les Alpes", "Le mur d''Hadrien", "Le Danube", "Le Rhin"]'::jsonb, 1, 'Geography', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-bd647bc28529b5a9', 'Europe is currently warming at a rate twice as high as the global average.', 'L''Europe se réchauffe actuellement deux fois plus vite que la moyenne mondiale.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Geography', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-13f802767a634c15', 'After the split of the Roman Empire in 395 AD, the Western Roman Empire was the only one to survive until the mid-15th century.', 'Après la scission de l''Empire romain en 395 apr. J.-C., seul l''Empire romain d''Occident a perduré jusqu''au milieu du XVe siècle.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 1, 'Geography', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-2c3f2fda7029e146', 'Why are the eastern borders of Europe considered geographically imprecise?', 'Pourquoi les frontières orientales de l''Europe sont-elles jugées géographiquement imprécises ?', '["Because the Arctic ice shelf makes mapping impossible.", "Because of the shifting tectonic plates under the Ural Mountains.", "Because Europe is a peninsula of the larger Eurasian landmass.", "Because the Black Sea is technically an inland lake."]'::jsonb, '["Parce que la banquise arctique rend le relevé cartographique impossible.", "À cause du déplacement des plaques tectoniques sous l''Oural.", "Car l''Europe est une péninsule de l''immense masse continentale eurasiatique.", "Parce que la mer Noire est techniquement un lac intérieur."]'::jsonb, 2, 'Geography', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-03c95e8adc4fde3a', 'According to Greek etymology, what does the name ''Europe'' literally mean?', 'Selon l''étymologie grecque, que signifie littéralement le nom « Europe » ?', '["Great water", "Setting sun", "Wide-eyed", "Golden land"]'::jsonb, '["Grande étendue d''eau", "Soleil couchant", "Celle qui a de grands yeux", "Terre dorée"]'::jsonb, 2, 'Geography', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-c9591466b39f4e5b', 'The Phoenician etymology for ''Europe'' suggests it comes from a word meaning ''the rising sun''.', 'L''étymologie phénicienne du nom « Europe » suggère qu''il provient d''un mot signifiant « le soleil levant ».', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 1, 'Geography', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-bf8c7d771c8bf21c', 'In the 13th century, which city was considered by some geographers as the eastern limit of Europe?', 'Au XIIIe siècle, quelle ville était considérée par certains géographes comme la limite orientale de l''Europe ?', '["Saint Petersburg", "Moscow", "Nizhny Novgorod", "Kiev"]'::jsonb, '["Saint-Pétersbourg", "Moscou", "Nijni Novgorod", "Kiev"]'::jsonb, 2, 'Geography', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-b7decbd57fc5d22c', 'Which area is home to the second largest continuous forest massif on the planet?', 'Quelle zone abrite le deuxième massif forestier continu de la planète ?', '["Congo Basin", "Nile Valley", "Sahara periphery", "Cape region"]'::jsonb, '["Bassin du Congo", "Vallée du Nil", "Périphérie du Sahara", "Région du Cap"]'::jsonb, 0, 'Geography', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-774e2e1332cb16fd', 'The Bantu expansion, a major population movement in Africa, originated from the region of present-day Cameroon.', 'L''expansion bantoue, mouvement de population majeur en Afrique, a pour origine la région du Cameroun actuel.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Geography', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-744df655ad5c6ca9', 'Africa possesses vast natural mountain aquifer systems that help regulate its climate.', 'L''Afrique possède de vastes systèmes montagneux aquifères qui aident à réguler son climat.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 1, 'Geography', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-6c04942f0f0abdcf', 'In the works of Pliny the Elder, which river is cited as the boundary between Africa and Ethiopia?', 'Dans les écrits de Pline l''Ancien, quel fleuve est cité comme la limite séparant l''Afrique de l''Éthiopie ?', '["The Zambezi", "The Niger", "The Congo", "The Nile"]'::jsonb, '["Le Zambèze", "Le Niger", "Le Congo", "Le Nil"]'::jsonb, 1, 'Geography', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-a85eb4467de9af14', 'According to linguist Michèle Fruyt, what did the Roman term ''africus'' originally refer to in Campania?', 'Selon la linguiste Michèle Fruyt, que désignait initialement le terme romain « africus » en Campanie ?', '["A rainy wind", "A dry desert storm", "A golden mineral", "A sacred harvest"]'::jsonb, '["Un vent pluvieux", "Une tempête de sable", "Un minerai doré", "Une récolte sacrée"]'::jsonb, 0, 'Geography', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-ee1906d2927164fb', 'Which of these bodies of water does NOT border the African continent to the northeast?', 'Lequel de ces plans d''eau ne borde PAS le continent africain au nord-est ?', '["The Red Sea", "The Persian Gulf", "The Gulf of Suez", "The Gulf of Aden"]'::jsonb, '["La mer Rouge", "Le golfe Persique", "Le golfe de Suez", "Le golfe d''Aden"]'::jsonb, 1, 'Geography', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-0b48f5ffa3a9c595', 'Despite being significantly larger than Europe, the African continent has a shorter coastline.', 'Bien qu''étant nettement plus vaste que l''Europe, le continent africain possède un littoral moins étendu.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Geography', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-5e8eb7380f2a096f', 'The term ''Africa'' is traditionally derived from the name of a Greek deity associated with the sea.', 'Le terme « Afrique » tire traditionnellement son origine du nom d''une divinité grecque associée à la mer.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 1, 'Geography', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-03e3eb71ae85b314', 'Approximately what percentage of Earth''s total land area does the continent of Asia cover?', 'Environ quel pourcentage des terres émergées de la planète le continent asiatique représente-t-il ?', '["43,8 %", "8,6 %", "29,4 %", "60 %"]'::jsonb, '["43,8 %", "8,6 %", "29,4 %", "60 %"]'::jsonb, 2, 'Geography', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-def870b06a9a51e0', 'In which country is the point on Earth furthest from any ocean located?', 'Dans quel pays se situe le point des terres émergées le plus éloigné de tout océan ?', '["Russia", "Kazakhstan", "India", "China"]'::jsonb, '["Russie", "Kazakhstan", "Inde", "Chine"]'::jsonb, 3, 'Geography', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-8ec123299b0099b7', 'Which mountain range was proposed by geographer Tatitchev in 1703 to serve as the border between Europe and Asia?', 'Quelle chaîne de montagnes a été proposée par le géographe Tatitchev en 1703 pour servir de frontière entre l''Europe et l''Asie ?', '["Himalayas", "Caucasus Mountains", "Altai Mountains", "Ural Mountains"]'::jsonb, '["Himalaya", "Caucase", "Monts Altaï", "Monts Oural"]'::jsonb, 3, 'Geography', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-e24649e8d15cd679', 'Asia is home to approximately 60% of the world''s population.', 'L''Asie concentre environ 60 % de la population mondiale.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Geography', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-7c2fceda3fbb1f2e', 'The Caspian Sea is the deepest lake in the world and holds 20% of the planet''s fresh water.', 'La mer Caspienne est le lac le plus profond du monde et contient 20 % des réserves d''eau douce de la planète.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 1, 'Geography', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-ae58b61db0df8b71', 'Which Greek historian divided the world into three parts named after mythological figures around 440 BC?', 'Quel historien grec a découpé le monde en trois parties nommées d''après des personnages mythologiques vers 440 av. J.-C. ?', '["Strabo", "Ptolemy", "Herodotus", "Homer"]'::jsonb, '["Strabon", "Ptolémée", "Hérodote", "Homère"]'::jsonb, 2, 'Geography', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-240a71d101d5e481', 'Which of these territories is considered part of Oceania rather than Asia according to the text?', 'Lequel de ces territoires est considéré comme faisant partie de l''Océanie plutôt que de l''Asie selon le texte ?', '["New Guinea", "The Philippines", "Timor-Leste", "Indonesia"]'::jsonb, '["La Nouvelle-Guinée", "Les Philippines", "Le Timor oriental", "L''Indonésie"]'::jsonb, 0, 'Geography', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-b60322ad74fadc57', 'In which country is the isthmus of Suez located, acting as a boundary between Asia and Africa?', 'Dans quel pays se trouve l''isthme de Suez, qui sert de frontière entre l''Asie et l''Afrique ?', '["Egypt", "Saudi Arabia", "Israel", "Jordan"]'::jsonb, '["L''Égypte", "L''Arabie saoudite", "Israël", "La Jordanie"]'::jsonb, 0, 'Geography', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-bd9b36b2e3d6e19b', 'According to the experts mentioned, the new ''horizontal'' Asia is organized along a north-south axis.', 'Selon les experts cités, la nouvelle Asie « horizontale » s''organise le long d''un axe nord-sud.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 1, 'Geography', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-1fd59c5dc2081c42', 'The Roman Empire once included a province specifically named ''Asia'', located in modern-day Anatolia.', 'L''Empire romain comprenait autrefois une province nommée « Asie », située dans l''actuelle Anatolie.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Geography', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-3969056f37df734d', 'Which four islands account for 95% of Japan''s land area?', 'Quelles sont les quatre îles qui représentent à elles seules 95 % de la superficie terrestre du Japon ?', '["Honshu, Hokkaido, Kyushu, Shikoku", "Kyushu, Shikoku, Sado, Honshu", "Honshu, Hokkaido, Okinawa, Shikoku", "Hokkaido, Kyushu, Awaji, Honshu"]'::jsonb, '["Honshū, Hokkaidō, Kyūshū, Shikoku", "Kyūshū, Shikoku, Sado, Honshū", "Honshū, Hokkaidō, Okinawa, Shikoku", "Hokkaidō, Kyūshū, Awaji, Honshū"]'::jsonb, 0, 'Geography', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-50d5d7daa6e52709', 'What does the name of Japan (Nihon/Nippon) literally translate to?', 'Que signifie littéralement le nom du Japon (Nihon/Nippon) en japonais ?', '["Origin of the sun", "Peaceful kingdom", "Eastern island nation", "Land of the mountains"]'::jsonb, '["Origine du soleil", "Royaume paisible", "Nation des îles de l''est", "Terre des montagnes"]'::jsonb, 0, 'Geography', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-07cc857976d90ea3', 'True or False: The Greater Tokyo area is the most populous metropolitan region in the world.', 'Vrai ou Faux : Le Grand Tokyo est la plus grande région métropolitaine au monde en termes de population.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Geography', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-17938b96b3f8170d', 'True or False: Japan has been experiencing a demographic decline since 1990.', 'Vrai ou Faux : Le Japon est en déclin démographique depuis l''année 1990.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 1, 'Geography', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-1d5349db8f9b6cb5', 'Which of these two terms for Japan is typically preferred for official contexts like banknotes or international sports events?', 'Lequel de ces deux termes pour désigner le Japon est privilégié pour les contextes officiels comme les billets de banque ou les événements sportifs ?', '["Nippon", "Cipangu", "Yamato", "Nihon"]'::jsonb, '["Nippon", "Cipangu", "Yamato", "Nihon"]'::jsonb, 0, 'Geography', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-0241e033eaf3d3eb', 'What specific term is used in Japanese media to refer to Japanese citizens living or traveling abroad?', 'Quel terme spécifique est utilisé dans les médias japonais pour désigner les citoyens japonais résidant ou voyageant à l''étranger ?', '["Yamato", "Hōjin", "Nihonjin", "Nikkeijin"]'::jsonb, '["Yamato", "Hōjin", "Nihonjin", "Nikkeijin"]'::jsonb, 1, 'Geography', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-be20ca38cb523ec2', 'The title of shogun, referring to the military commanders-in-chief, was established in the 15th century.', 'Le titre de shogun, désignant les généraux en chef des armées, a été instauré au XVe siècle.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 1, 'Geography', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-8dd1585d1701f25b', 'Which major battle in 1600 allowed Tokugawa Ieyasu to establish his shogunate?', 'Quelle bataille majeure de 1600 a permis à Tokugawa Ieyasu d''établir son shogunat ?', '["Edo", "Yamato", "Sekigahara", "Nara"]'::jsonb, '["Edo", "Yamato", "Sekigahara", "Nara"]'::jsonb, 2, 'Geography', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-199a2613dba4a79d', 'What is the approximate distribution of Russia''s territory between Asia and Europe?', 'Quelle est la répartition approximative du territoire russe entre l''Asie et l''Europe ?', '["80% Asia, 20% Europe", "90% Asia, 10% Europe", "60% Asia, 40% Europe", "50% Asia, 50% Europe"]'::jsonb, '["80 % Asie, 20 % Europe", "90 % Asie, 10 % Europe", "60 % Asie, 40 % Europe", "50 % Asie, 50 % Europe"]'::jsonb, 0, 'Geography', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-14df381a823f2aa9', 'Most of the Russian territory is covered by the tundra.', 'La majorité du territoire russe est occupée par la toundra.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 1, 'Geography', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-0f47c920dbc58412', 'Approximately what percentage of the Russian population lives in the European part of the country?', 'Quel pourcentage approximatif de la population russe vit dans la partie européenne du pays ?', '["89%", "62%", "55%", "78%"]'::jsonb, '["89 %", "62 %", "55 %", "78 %"]'::jsonb, 3, 'Geography', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-259fe80a6541caf0', 'Lake Baikal contains approximately 20% of the Earth''s liquid surface freshwater.', 'Le lac Baïkal contient environ 20 % de l''eau douce lacustre de la planète.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Geography', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-cf6e4bd6050d480a', 'In the majority of Russia, the transition between the coldest and warmest temperatures takes place over a very long period, with distinct spring and autumn seasons.', 'Dans la majeure partie de la Russie, le passage entre les températures les plus froides et les plus chaudes s''étale sur une très longue période, avec des saisons de printemps et d''automne marquées.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 1, 'Geography', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-fba80a15ddf7fc25', 'Approximately what percentage of the total Russian territory is classified as arable land?', 'Quel pourcentage approximatif du territoire russe est constitué de terres arables ?', '["15.5%", "45.0%", "22.1%", "6.8%"]'::jsonb, '["15,5 %", "45,0 %", "22,1 %", "6,8 %"]'::jsonb, 3, 'Geography', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-3b39e51408c6ace6', 'What is the primary energy source used by plants to produce their own organic matter?', 'Quelle est la source d''énergie principale utilisée par les plantes pour produire leur propre matière organique ?', '["Ambient heat", "Atmospheric nitrogen", "Soil minerals", "Sunlight"]'::jsonb, '["La chaleur ambiante", "L''azote atmosphérique", "Les minéraux du sol", "La lumière du soleil"]'::jsonb, 3, 'Science & Nature', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-15731fda2d357d69', 'Which pigment is responsible for capturing light energy in plants?', 'Quel pigment est responsable de la capture de l''énergie lumineuse chez les plantes ?', '["Hemoglobin", "Melanin", "Carotene", "Chlorophyll"]'::jsonb, '["L''hémoglobine", "La mélanine", "Le carotène", "La chlorophylle"]'::jsonb, 3, 'Science & Nature', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-99731c3799f73940', 'What is the main gas that makes up the Earth''s atmosphere today?', 'Quel est le gaz qui compose la majeure partie de l''atmosphère terrestre actuelle ?', '["Nitrogen", "Hydrogen", "Carbon dioxide", "Oxygen"]'::jsonb, '["Le diazote", "L''hydrogène", "Le dioxyde de carbone", "Le dioxygène"]'::jsonb, 0, 'Science & Nature', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-889bb2d94f7e8f2f', 'Photosynthesis is essentially the reverse process of cellular respiration.', 'La photosynthèse est globalement l''inverse de la respiration cellulaire.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Science & Nature', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-a6064bfa55f0c429', 'All types of photosynthesis release oxygen as a byproduct.', 'Tous les types de photosynthèse libèrent du dioxygène comme sous-produit.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 1, 'Science & Nature', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-46604fdddede30de', 'What is the name of the cycle used by plants to produce carbohydrates during photosynthesis?', 'Comment s''appelle le cycle utilisé par les plantes pour produire des glucides lors de la photosynthèse ?', '["Krebs cycle", "Oxygen cycle", "Calvin cycle", "Carbon cycle"]'::jsonb, '["Le cycle de Krebs", "Le cycle de l''oxygène", "Le cycle de Calvin", "Le cycle du carbone"]'::jsonb, 2, 'Science & Nature', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-0dde92d08fbf2419', 'In which specific organelle does photosynthesis occur in plants?', 'Dans quel organite se déroule la photosynthèse chez les plantes ?', '["Nucleus", "Chloroplast", "Mitochondrion", "Ribosome"]'::jsonb, '["Le noyau", "Le chloroplaste", "La mitochondrie", "Le ribosome"]'::jsonb, 1, 'Science & Nature', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-1e98c6fdd7176268', 'There is a species of sea slug that is capable of photosynthesis.', 'Il existe une espèce de limace de mer capable de réaliser la photosynthèse.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Science & Nature', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-d17d2598be2c596a', 'What are the stacks of thylakoids found inside a chloroplast called?', 'Comment appelle-t-on les empilements de thylakoïdes situés dans le chloroplaste ?', '["Lumen", "Stroma", "Grana", "Matrix"]'::jsonb, '["Le lumen", "Le stroma", "Des grana", "La matrice"]'::jsonb, 2, 'Science & Nature', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-c54b807ce5d6b868', 'Photosynthesis can occur in total darkness without any light source.', 'La photosynthèse peut se dérouler dans l''obscurité totale sans aucune source de lumière.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 1, 'Science & Nature', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-dbe2adc2a7d55412', 'What is the characteristic shape of the DNA molecule?', 'Quelle est la forme caractéristique de la molécule d''ADN ?', '["Triple spiral", "Double helix", "Single ring", "Linear chain"]'::jsonb, '["Triple spirale", "Double hélice", "Anneau unique", "Chaîne linéaire"]'::jsonb, 1, 'Science & Nature', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-6751cb66efb5c6f3', 'Which of these is NOT one of the four bases found in DNA?', 'Parmi ces bases, laquelle ne fait PAS partie des quatre bases constituant l''ADN ?', '["Uracil", "Guanine", "Cytosine", "Adenine"]'::jsonb, '["Uracile", "Guanine", "Cytosine", "Adénine"]'::jsonb, 0, 'Science & Nature', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-fc626b32e9e5938e', 'DNA is the biological support for heredity.', 'L''ADN est le support biologique de l''hérédité.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Science & Nature', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-e87f25eaca6755cf', 'How many hydrogen bonds form between Guanine and Cytosine?', 'Combien de liaisons hydrogène unissent la guanine et la cytosine ?', '["Five", "Three", "Two", "Four"]'::jsonb, '["Cinq", "Trois", "Deux", "Quatre"]'::jsonb, 1, 'Science & Nature', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-28c19e8909570b75', 'In humans, the majority of DNA is stored in the cytoplasm of cells.', 'Chez l''être humain, la majeure partie de l''ADN est stockée dans le cytoplasme des cellules.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 1, 'Science & Nature', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-bb3c95cad74e56e2', 'What is the name of the substance formed by DNA and histone proteins?', 'Comment appelle-t-on la substance formée par l''ADN et les protéines appelées histones ?', '["Capsid", "Cytoplasm", "Ribosome", "Chromatin"]'::jsonb, '["Capside", "Cytoplasme", "Ribosome", "Chromatine"]'::jsonb, 3, 'Science & Nature', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-54fc1830f039a143', 'What type of sugar molecule is found in the backbone of DNA?', 'Quel type de sucre constitue le squelette de la molécule d''ADN ?', '["Lactose", "Deoxyribose", "Fructose", "Glucose"]'::jsonb, '["Lactose", "Désoxyribose", "Fructose", "Glucose"]'::jsonb, 1, 'Science & Nature', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-6d481aad80072075', 'RNA and DNA are both types of polynucleotides.', 'L''ARN et l''ADN sont tous deux des polynucléotides.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Science & Nature', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-ffb4d0208a61a5a1', 'In DNA, Adenine always pairs with Guanine.', 'Dans l''ADN, l''adénine s''associe toujours avec la guanine.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 1, 'Science & Nature', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-7b4e4ffb342d0e25', 'In what year was DNA first identified and isolated?', 'En quelle année l''ADN a-t-il été identifié et isolé pour la première fois ?', '["1902", "1869", "1924", "1953"]'::jsonb, '["1902", "1869", "1924", "1953"]'::jsonb, 1, 'Science & Nature', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-b34f206a60ab2add', 'Where is the vast majority of an atom''s mass located?', 'Où se concentre la très grande majorité de la masse d''un atome ?', '["In the empty space", "In the orbital clouds", "In the electrons", "In the nucleus"]'::jsonb, '["Dans le vide", "Dans les nuages orbitaux", "Dans les électrons", "Dans le noyau"]'::jsonb, 3, 'Science & Nature', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-c1e194b83dbfc783', 'Which of these particles is found orbiting the nucleus of an atom?', 'Parmi ces particules, laquelle gravite autour du noyau d''un atome ?', '["Protons", "Nucleons", "Neutrons", "Electrons"]'::jsonb, '["Les protons", "Les nucléons", "Les neutrons", "Les électrons"]'::jsonb, 3, 'Science & Nature', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-116233f618615639', 'Which chemical element is the only one whose standard nucleus contains no neutrons?', 'Quel élément chimique est le seul dont le noyau standard ne contient aucun neutron ?', '["Oxygen", "Helium", "Hydrogen", "Carbon"]'::jsonb, '["L''oxygène", "L''hélium", "L''hydrogène", "Le carbone"]'::jsonb, 2, 'Science & Nature', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-df04b2ab23973420', 'The vast majority of an atom''s volume is made up of empty space.', 'La très grande majorité du volume d''un atome est constituée de vide.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Science & Nature', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-c2dc96c7bcac7934', 'The word ''atom'' comes from a Greek term meaning ''infinitely divisible''.', 'Le mot « atome » provient d''un terme grec signifiant « infiniment divisible ».', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 1, 'Science & Nature', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-09b21ace3d619bc6', 'What specific value determines the identity of a chemical element?', 'Quelle valeur spécifique détermine l''identité d''un élément chimique ?', '["The number of electron shells", "The number of protons", "The number of neutrons", "The total mass"]'::jsonb, '["Le nombre de couches électroniques", "Le nombre de protons", "Le nombre de neutrons", "La masse totale"]'::jsonb, 1, 'Science & Nature', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-a733b4aee06357b1', 'Which of these particles are found inside an atom?', 'Quelles sont les particules qui composent un atome ?', '["Protons, neutrons and electrons", "Nucleons, ions and molecules", "Photons, gluons and atoms", "Quarks, leptons and bosons"]'::jsonb, '["Protons, neutrons et électrons", "Nucléons, ions et molécules", "Photons, gluons et atomes", "Quarks, leptons et bosons"]'::jsonb, 0, 'Science & Nature', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-86897bcdb74fac10', 'The neutron is a particle that carries a negative electrical charge.', 'Le neutron est une particule qui porte une charge électrique négative.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 1, 'Science & Nature', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-e36443ed186c41f7', 'What is the composition of a proton in terms of quarks?', 'De quels quarks est composé un proton ?', '["Three up quarks", "Two down quarks and one up quark", "Three down quarks", "Two up quarks and one down quark"]'::jsonb, '["Trois quarks up", "Deux quarks down et un quark up", "Trois quarks down", "Deux quarks up et un quark down"]'::jsonb, 3, 'Science & Nature', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-cafce6f8a24517d0', 'An electron can behave like both a wave and a particle.', 'L''électron peut se comporter à la fois comme une onde et comme une particule.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Science & Nature', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-2f965e5ea321440c', 'Which interaction do electrons, as leptons, NOT experience?', 'Quelle interaction les électrons, en tant que leptons, ne connaissent-ils pas ?', '["Weak interaction", "Electromagnetic interaction", "Strong nuclear interaction", "Gravitational interaction"]'::jsonb, '["Interaction faible", "Interaction électromagnétique", "Interaction nucléaire forte", "Interaction gravitationnelle"]'::jsonb, 2, 'Science & Nature', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-0b9ee433c67c2156', 'How many quantum numbers are used to describe an electron in an atom?', 'Combien de nombres quantiques sont nécessaires pour décrire un électron dans un atome ?', '["Five", "Three", "Four", "Two"]'::jsonb, '["Cinq", "Trois", "Quatre", "Deux"]'::jsonb, 2, 'Science & Nature', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-4bde83b36d7b0b27', 'Which phenomenon is closely linked to electricity to form electromagnetism?', 'Quel phénomène est étroitement lié à l''électricité pour former l''électromagnétisme ?', '["Radioactivity", "Gravity", "Thermodynamics", "Magnetism"]'::jsonb, '["La radioactivité", "La gravité", "La thermodynamique", "Le magnétisme"]'::jsonb, 3, 'Science & Nature', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-7ea4db7c9c966a5e', 'From which material does the word ''electricity'' originate?', 'De quelle matière provient le mot « électricité » ?', '["Amber", "Quartz", "Magnetite", "Copper"]'::jsonb, '["L''ambre", "Le quartz", "La magnétite", "Le cuivre"]'::jsonb, 0, 'Science & Nature', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-9eabb0ddc9069027', 'What did Ancient Egyptians call the electric fish they observed in the Nile?', 'Comment les Égyptiens de l''Antiquité appelaient-ils les poissons électriques observés dans le Nil ?', '["Thunder of the Nile", "Shocking Eel", "Nile Spark", "Electric Pharaoh"]'::jsonb, '["Tonnerre du Nil", "Anguille choc", "Étincelle du Nil", "Pharaon électrique"]'::jsonb, 0, 'Science & Nature', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-b490c02a4225777e', 'Benjamin Franklin demonstrated the electrical nature of lightning using a kite.', 'Benjamin Franklin a démontré la nature électrique de la foudre à l''aide d''un cerf-volant.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Science & Nature', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-abe3dfd2427ca5c2', 'Thales believed that rubbing amber made it magnetic.', 'Thalès pensait que le frottement rendait l''ambre magnétique.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Science & Nature', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-daa6da5f3f83b8c5', 'Which law determines the magnitude of the force exerted on an electric charge in an electric field?', 'Quelle loi permet de déterminer l''ampleur de la force exercée sur une charge électrique dans un champ électrique ?', '["Gilbert''s law", "Franklin''s law", "Maxwell''s law", "Coulomb''s law"]'::jsonb, '["La loi de Gilbert", "La loi de Franklin", "La loi de Maxwell", "La loi de Coulomb"]'::jsonb, 3, 'Science & Nature', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-3de1d1571993afe8', 'Which two metals were used in Alessandro Volta''s original battery?', 'Quels sont les deux métaux utilisés dans la pile originale d''Alessandro Volta ?', '["Gold and silver", "Nickel and aluminum", "Iron and lead", "Zinc and copper"]'::jsonb, '["Or et argent", "Nickel et aluminium", "Fer et plomb", "Zinc et cuivre"]'::jsonb, 3, 'Science & Nature', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-d9fcd957b3bc1436', 'Which electronic component is considered the most manufactured device in history?', 'Quel composant électronique est considéré comme l''objet le plus fabriqué de l''histoire ?', '["Vacuum tube", "Transistor bipolar", "MOSFET", "Crystal detector"]'::jsonb, '["Tube à vide", "Transistor bipolaire", "MOSFET", "Détecteur de cristal"]'::jsonb, 2, 'Science & Nature', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-e8018c799a52db4d', 'Objects with the same electrical charge attract each other.', 'Les objets ayant une charge électrique identique s''attirent entre eux.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 1, 'Science & Nature', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-2a93a24640d5e2e5', 'Who is credited with the invention of the electric motor in 1821?', 'Qui a inventé le moteur électrique en 1821 ?', '["Thomas Edison", "Nikola Tesla", "Michael Faraday", "Alessandro Volta"]'::jsonb, '["Thomas Edison", "Nikola Tesla", "Michael Faraday", "Alessandro Volta"]'::jsonb, 2, 'Science & Nature', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-12962f7f13575ffe', 'Albert Einstein published a famous paper on the photoelectric effect in 1905.', 'Albert Einstein a publié un article célèbre sur l''effet photoélectrique en 1905.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Science & Nature', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-d3acafaabea05357', 'Where was the first functional transistor invented in 1947?', 'Où le premier transistor fonctionnel a-t-il été inventé en 1947 ?', '["NASA", "MIT", "Bell Laboratories", "Silicon Valley"]'::jsonb, '["NASA", "MIT", "Laboratoires Bell", "Silicon Valley"]'::jsonb, 2, 'Science & Nature', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-f3d1190d0164b05f', 'Which famous physicist is known for the theory of general relativity?', 'Quel célèbre physicien est à l''origine de la théorie de la relativité générale ?', '["Galileo Galilei", "Isaac Newton", "Albert Einstein", "Archimedes"]'::jsonb, '["Galilée", "Isaac Newton", "Albert Einstein", "Archimède"]'::jsonb, 2, 'Science & Nature', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-9f31dee119f9b381', 'Gravity is one of the four fundamental interactions that govern the Universe.', 'La gravitation est l''une des quatre interactions fondamentales qui régissent l''Univers.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Science & Nature', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-13475bba01d520dd', 'Who was the first to understand that air resistance is the cause of differences in falling speeds?', 'Qui fut le premier à comprendre que les frottements de l''air expliquent les différences de vitesse de chute des objets ?', '["Galileo", "Archimedes", "Newton", "Einstein"]'::jsonb, '["Galilée", "Archimède", "Newton", "Einstein"]'::jsonb, 0, 'Science & Nature', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-38564b7a14683a34', 'A satellite in orbit around the Earth is subjected to ''gravity'' rather than ''weight'' (pesanteur).', 'Un satellite en orbite autour de la Terre est soumis à la gravité plutôt qu''à la pesanteur.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Science & Nature', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-248ad5d989ac099d', 'At the microscopic scale, how does gravity compare to the other fundamental interactions?', 'À l''échelle microscopique, comment se situe la gravitation par rapport aux autres interactions fondamentales ?', '["It is the strongest", "It is the most volatile", "It is equal to electromagnetism", "It is the weakest"]'::jsonb, '["C''est la plus forte", "C''est la plus instable", "Elle est égale à l''électromagnétisme", "C''est la plus faible"]'::jsonb, 3, 'Science & Nature', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-faee2433aa1dd805', 'Which geometric shape''s center of gravity was discovered by Archimedes?', 'Le centre de gravité de quelle forme géométrique a été découvert par Archimède ?', '["A triangle", "A sphere", "A circle", "A square"]'::jsonb, '["Un triangle", "Une sphère", "Un cercle", "Un carré"]'::jsonb, 0, 'Science & Nature', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-a7b10b3a0fb65652', 'Which famous Italian scientist is associated with the myth of dropping objects from the Leaning Tower of Pisa?', 'Quel célèbre scientifique italien est associé au mythe de l''expérience de la tour de Pise ?', '["Christiaan Huygens", "Galileo", "Isaac Newton", "Nicolas Oresme"]'::jsonb, '["Christiaan Huygens", "Galilée", "Isaac Newton", "Nicolas Oresme"]'::jsonb, 1, 'Science & Nature', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-e4bfa417d14c3a25', 'Isaac Newton''s theory of mechanics is primarily based on the study of what?', 'La théorie de la mécanique d''Isaac Newton repose principalement sur l''étude de quoi ?', '["Temperature", "Light refraction", "Acceleration", "Magnetism"]'::jsonb, '["La température", "La réfraction de la lumière", "L''accélération", "Le magnétisme"]'::jsonb, 2, 'Science & Nature', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-7ef7082198281353', 'According to Galileo''s law of falling bodies, speed is proportional to what?', 'Selon la loi de la chute des corps de Galilée, la vitesse est proportionnelle à quoi ?', '["Initial height", "Time elapsed", "Total mass", "Air resistance"]'::jsonb, '["Hauteur initiale", "Temps écoulé", "Masse totale", "Résistance de l''air"]'::jsonb, 1, 'Science & Nature', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-4668a272f04b0465', 'Which scientist published ''On the Origin of Species'' in 1859?', 'Quel scientifique a publié ''L''Origine des espèces'' en 1859 ?', '["Gregor Mendel", "Jean-Baptiste de Lamarck", "August Weismann", "Charles Darwin"]'::jsonb, '["Gregor Mendel", "Jean-Baptiste de Lamarck", "August Weismann", "Charles Darwin"]'::jsonb, 3, 'Science & Nature', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-78ee6be59c2bfea2', 'Evolution is the process that explains the biodiversity on Earth.', 'L''évolution est le processus qui explique la biodiversité sur Terre.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Science & Nature', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-9624eec88febb110', 'August Weismann demonstrated that acquired traits can be passed down to offspring.', 'August Weismann a démontré que les caractères acquis peuvent être transmis à la descendance.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 1, 'Science & Nature', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-896521ee0dce72d8', 'Which of these is one of the two principles of Jean-Baptiste de Lamarck''s theory?', 'Lequel de ces principes fait partie de la théorie de Jean-Baptiste de Lamarck ?', '["Natural selection", "Genetic mutation", "Complexification of the organism", "Symbiogenesis"]'::jsonb, '["Sélection naturelle", "Mutation génétique", "Complexification de l''organisme", "Symbiogenèse"]'::jsonb, 2, 'Science & Nature', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-9629c5bac375620f', 'What is the term for the process where two species fuse to form a new one?', 'Comment appelle-t-on le processus où deux espèces fusionnent pour en créer une nouvelle ?', '["Natural selection", "Symbiogenesis", "Evolutionary stagnation", "Genetic drift"]'::jsonb, '["Sélection naturelle", "Symbiogenèse", "Stagnation évolutive", "Dérive génétique"]'::jsonb, 1, 'Science & Nature', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-bea471117f406271', 'As early as the 9th century, the scholar Al-Jahiz proposed ideas suggesting that species evolve over time.', 'Dès le IXe siècle, le savant Al-Jahiz a émis des idées suggérant que les espèces évoluent au cours du temps.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Science & Nature', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-7d829dbddd89af9f', 'Which theory did Georges Cuvier use to explain the existence of extinct species without accepting evolution?', 'Quelle théorie Georges Cuvier a-t-il utilisée pour expliquer les espèces éteintes sans accepter l''évolution ?', '["Catastrophism", "Spontaneous generation", "Genetic mutation", "Natural selection"]'::jsonb, '["Le catastrophisme", "La génération spontanée", "La mutation génétique", "La sélection naturelle"]'::jsonb, 0, 'Science & Nature', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-ded667c41bcb5d99', 'Jean-Baptiste de Lamarck is the scientist who originally developed the theory of the transmission of acquired characteristics.', 'Jean-Baptiste de Lamarck est le scientifique qui a initialement développé la théorie de la transmission des caractères acquis.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 1, 'Science & Nature', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-e1e2b9e0a24ebb51', 'The ''synthetic theory of evolution'' emerged in the 1940s by combining Darwinism with which other field?', 'La ''théorie synthétique de l''évolution'' est née dans les années 1940 en associant le darwinisme à quel autre domaine ?', '["Paleontology", "Chemistry", "Genetics", "Physics"]'::jsonb, '["La paléontologie", "La chimie", "La génétique", "La physique"]'::jsonb, 2, 'Science & Nature', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-1d5c4e3c0231c29d', 'Which French naturalist transformed the Jardin des Plantes into a major center for collection and study?', 'Quel naturaliste français a transformé le Jardin des plantes en un centre de collection et d''étude ?', '["Pierre Louis Moreau de Maupertuis", "Georges Cuvier", "Jean-Baptiste de Lamarck", "Comte de Buffon"]'::jsonb, '["Pierre Louis Moreau de Maupertuis", "Georges Cuvier", "Jean-Baptiste de Lamarck", "Le comte de Buffon"]'::jsonb, 3, 'Science & Nature', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-62d20361dc074a1d', 'What is considered the basic structural and functional unit of all known living organisms?', 'Quelle est l''unité biologique structurelle et fonctionnelle fondamentale de tous les êtres vivants ?', '["The organ", "The protein", "The atom", "The cell"]'::jsonb, '["L''organe", "La protéine", "L''atome", "La cellule"]'::jsonb, 3, 'Science & Nature', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-83dc1188a1f491ce', 'Plants and animals are examples of multicellular organisms.', 'Les plantes et les animaux sont des exemples d''organismes multicellulaires.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Science & Nature', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-54c3eeb325c59649', 'Which naturalist coined the term ''cell'' by comparing them to honeycombs?', 'Quel naturaliste a donné le nom de « cellule » en les comparant aux alvéoles d''une ruche ?', '["Charles Darwin", "Robert Hooke", "Theodor Schwann", "Matthias Jakob Schleiden"]'::jsonb, '["Charles Darwin", "Robert Hooke", "Theodor Schwann", "Matthias Jakob Schleiden"]'::jsonb, 1, 'Science & Nature', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-fdd4d2586feab196', 'Prokaryotic cells are defined by having a nucleus wrapped in a nuclear membrane.', 'Les cellules procaryotes se définissent par la présence d''un noyau enveloppé d''une membrane nucléaire.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 1, 'Science & Nature', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-8855b9d71afe5aaa', 'What is the primary substance that makes up the cell wall of bacteria?', 'Quelle est la substance principale qui compose la paroi cellulaire des bactéries ?', '["Chitin", "Cellulose", "Peptidoglycan", "Collagen"]'::jsonb, '["Chitine", "Cellulose", "Peptidoglycane", "Collagène"]'::jsonb, 2, 'Science & Nature', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-d579777f863b1999', 'What is the name of the region in a prokaryotic cell where the DNA is located?', 'Comment appelle-t-on la région d''une cellule procaryote où se trouve l''ADN ?', '["Nucleoid", "Cytosol", "Nucleus", "Nucleolus"]'::jsonb, '["Nucléoïde", "Cytosol", "Noyau", "Nucléole"]'::jsonb, 0, 'Science & Nature', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-b3b63bd564dff2dc', 'What does the term ''eukaryote'' literally mean?', 'Que signifie littéralement le terme « eucaryote » ?', '["Large cell", "Living organism", "Specialized membrane", "True nucleus"]'::jsonb, '["Grande cellule", "Organisme vivant", "Membrane spécialisée", "Vrai noyau"]'::jsonb, 3, 'Science & Nature', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-32be988097198bfc', 'Which of these cells lack a nucleus?', 'Laquelle de ces cellules ne possède pas de noyau ?', '["Protozoa", "Fungal cells", "Red blood cells", "Plant cells"]'::jsonb, '["Protozoaires", "Cellules de champignons", "Globules rouges", "Cellules végétales"]'::jsonb, 2, 'Science & Nature', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-2e497cd4da99e608', 'Which disease is caused by the bacterium Borrelia burgdorferi?', 'Quelle maladie est causée par la bactérie Borrelia burgdorferi ?', '["Lyme disease", "Cholera", "Malaria", "Tuberculosis"]'::jsonb, '["Maladie de Lyme", "Choléra", "Paludisme", "Tuberculose"]'::jsonb, 0, 'Science & Nature', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-de78681ce2700373', 'Plants and animals are both classified as eukaryotes.', 'Les plantes et les animaux sont tous deux classés comme des eucaryotes.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Science & Nature', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-369f2a11d8b3f77e', 'What is the main component of a plant cell wall?', 'Quel est le constituant principal de la paroi d''une cellule végétale ?', '["Proteins", "Cellulose", "Lipids", "Hemoglobin"]'::jsonb, '["Protéines", "Cellulose", "Lipides", "Hémoglobine"]'::jsonb, 1, 'Science & Nature', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-d35c62d8ef6fa105', 'From which animal does the word ''vaccine'' etymologically originate?', 'De quel animal le mot « vaccin » tire-t-il ses origines étymologiques ?', '["Pig", "Chicken", "Horse", "Cow"]'::jsonb, '["Cochon", "Poulet", "Cheval", "Vache"]'::jsonb, 3, 'Science & Nature', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-5423c21ce4e5ddf0', 'In the 10th century, how did the Chinese practice early smallpox inoculation?', 'Au Xe siècle, comment les Chinois pratiquaient-ils une forme ancienne d''inoculation contre la variole ?', '["Nasal insufflation", "Skin acupuncture", "Applying hot poultices", "Drinking herbal tea"]'::jsonb, '["Insufflation nasale", "Par acupuncture", "Par des cataplasmes chauds", "En buvant des tisanes"]'::jsonb, 0, 'Science & Nature', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-a9072dee9ea1bf5f', 'What is the main goal of a vaccine regarding the immune system?', 'Quel est le rôle principal d''un vaccin pour le système immunitaire ?', '["To kill all existing bacteria", "To replace white blood cells", "To create a memory of the pathogen", "To increase body temperature"]'::jsonb, '["Détruire toutes les bactéries du corps", "Remplacer les globules blancs", "Garder en mémoire l''agent pathogène", "Augmenter la température corporelle"]'::jsonb, 2, 'Science & Nature', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-e84766e33bb4e738', 'Louis Pasteur is the scientist who proposed extending the terms ''vaccine'' and ''vaccination'' to other diseases.', 'Louis Pasteur est le scientifique qui a proposé d''étendre les termes « vaccin » et « vaccination » à d''autres maladies.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Science & Nature', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-2a9a321e78d1bcbc', 'Smallpox is a disease that has been completely eradicated worldwide thanks to vaccination.', 'La variole est une maladie qui a été totalement éradiquée dans le monde grâce à la vaccination.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Science & Nature', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-4466d244f9ace1f2', 'Who was the young boy used by Edward Jenner in his first successful vaccination experiment?', 'Quel était le prénom du jeune garçon utilisé par Edward Jenner lors de sa première expérience de vaccination réussie ?', '["James Phipps", "Maurice Hilleman", "Louis Pasteur", "Edward Jenner"]'::jsonb, '["James Phipps", "Maurice Hilleman", "Louis Pasteur", "Edward Jenner"]'::jsonb, 0, 'Science & Nature', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-16fe076eefe4680a', 'What do vaccines primarily help the body to produce?', 'Que permettent principalement de produire les vaccins dans l''organisme ?', '["Digestive enzymes", "Red blood cells", "Skin cells", "Antibodies"]'::jsonb, '["Des enzymes digestives", "Des globules rouges", "Des cellules cutanées", "Des anticorps"]'::jsonb, 3, 'Science & Nature', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-9e8ea15a432a7638', 'Most vaccines are preventative (prophylactic) rather than curative.', 'La plupart des vaccins sont préventifs (prophylactiques) plutôt que curatifs.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Science & Nature', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-c76d0e3aa8c5c681', 'Which common ingredient is used to prepare flu vaccines?', 'Quel ingrédient courant est utilisé pour préparer les vaccins contre la grippe ?', '["Milk protein", "Egg protein", "Wheat protein", "Soy protein"]'::jsonb, '["La protéine de lait", "La protéine d''œuf", "La protéine de blé", "La protéine de soja"]'::jsonb, 1, 'Science & Nature', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-3d9390e9d2c6c570', 'The body immediately produces antibodies the same day a vaccine is administered.', 'L''organisme produit immédiatement des anticorps le jour même de la vaccination.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 1, 'Science & Nature', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-ac9efd103a266f70', 'Which vaccine is known for relying on cellular immunity rather than antibody production?', 'Quel vaccin est connu pour reposer sur l''immunité cellulaire plutôt que sur la production d''anticorps ?', '["BCG vaccine", "Flu vaccine", "Tetanus vaccine", "Hepatitis B vaccine"]'::jsonb, '["Le vaccin BCG", "Le vaccin contre la grippe", "Le vaccin antitétanique", "Le vaccin contre l''hépatite B"]'::jsonb, 0, 'Science & Nature', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-24edc532a73e4ac9', 'What is the primary role of an adjuvant in a vaccine?', 'Quel est le rôle principal d''un adjuvant dans un vaccin ?', '["Increase the vaccine weight", "Change the vaccine flavor", "Stimulate the immune response", "Kill the virus directly"]'::jsonb, '["Augmenter le poids du vaccin", "Changer le goût du vaccin", "Stimuler la réponse immunitaire", "Tuer directement le virus"]'::jsonb, 2, 'Science & Nature', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-d5806a7c9f2bd280', 'From which organism is penicillin naturally derived?', 'De quel organisme provient naturellement la pénicilline ?', '["Plants", "Bacteria", "Mold", "Algae"]'::jsonb, '["Des plantes", "Des bactéries", "Des moisissures", "Des algues"]'::jsonb, 2, 'Science & Nature', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-c7b991dc95924ae3', 'Which scientist is credited with the accidental discovery of penicillin in 1928?', 'Quel scientifique a découvert la pénicilline par accident en 1928 ?', '["Alexander Fleming", "Ernst Chain", "Ernest Duchesne", "Howard Florey"]'::jsonb, '["Alexander Fleming", "Ernst Chain", "Ernest Duchesne", "Howard Florey"]'::jsonb, 0, 'Science & Nature', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-423a45195063d3d5', 'Penicillin is primarily used to treat bacterial infections.', 'La pénicilline est principalement utilisée pour traiter des infections bactériennes.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Science & Nature', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-5aac08ca5315c59d', 'What substance is often added to penicillin to prevent bacteria from neutralizing it?', 'Quelle substance ajoute-t-on souvent à la pénicilline pour empêcher les bactéries de l''inactiver ?', '["Citric acid", "Acetic acid", "Ascorbic acid", "Clavulanic acid"]'::jsonb, '["L''acide citrique", "L''acide acétique", "L''acide ascorbique", "L''acide clavulanique"]'::jsonb, 3, 'Science & Nature', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-7d31d2e741e6805f', 'It is impossible for a human to be allergic to penicillin.', 'Il est impossible pour un humain d''être allergique à la pénicilline.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 1, 'Science & Nature', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-74eeb3573e3e1258', 'How does penicillin kill bacteria?', 'Comment la pénicilline tue-t-elle les bactéries ?', '["By freezing their DNA", "By preventing cell wall synthesis", "By starving them of oxygen", "By blocking their vision"]'::jsonb, '["En gelant leur ADN", "En empêchant la synthèse de la paroi cellulaire", "En les privant d''oxygène", "En bloquant leur vision"]'::jsonb, 1, 'Science & Nature', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-daf1e6e12779ed43', 'What is the common commercial name for amoxicillin?', 'Quel est le nom commercial courant de l''amoxicilline ?', '["Oracilline", "Totapen", "Clamoxyl", "Unacim"]'::jsonb, '["Oracilline", "Totapen", "Clamoxyl", "Unacim"]'::jsonb, 2, 'Science & Nature', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-0fc112705d3efad4', 'Penicillin V is mainly eliminated from the body through the urinary tract.', 'La pénicilline V est principalement éliminée de l''organisme par les voies urinaires.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Science & Nature', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-fc4526362b468c31', 'Which side effect is frequently associated with intravenous cloxacillin?', 'Quel effet secondaire est fréquemment associé à l''administration intraveineuse de cloxacilline ?', '["Respiratory distress", "Muscle cramps", "Vein inflammation", "Severe headaches"]'::jsonb, '["Détresse respiratoire", "Crampes musculaires", "Inflammation des veines", "Maux de tête sévères"]'::jsonb, 2, 'Science & Nature', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-883babe62d86409b', 'A bacterium resistant to methicillin is generally still sensitive to other types of penicillin.', 'Une bactérie résistante à la méticilline est généralement encore sensible aux autres types de pénicilline.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 1, 'Science & Nature', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-f91a2dd2df0a0a02', 'In which medical context is penicillin V used as a reference antibiotic prophylaxis?', 'Dans quel contexte médical la pénicilline V est-elle utilisée comme antibiotique de référence en prévention ?', '["Appendicitis", "Bone fracture", "Spleen removal", "Skin allergy"]'::jsonb, '["Appendicite", "Fracture osseuse", "Ablation de la rate", "Allergie cutanée"]'::jsonb, 2, 'Science & Nature', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-0cbebe5ae8385770', 'Which bacterium is known for producing penicillinases that neutralize conventional penicillins?', 'Quelle bactérie est connue pour produire des pénicillinases qui neutralisent les pénicillines conventionnelles ?', '["Escherichia coli", "Streptococcus", "Staphylococcus aureus", "Haemophilus influenzae"]'::jsonb, '["Escherichia coli", "Streptocoque", "Staphylocoque doré", "Haemophilus influenzae"]'::jsonb, 2, 'Science & Nature', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-cbb6e2ebeb4375db', 'Which chemist is famous for having designed the first version of the periodic table in 1869?', 'Quel chimiste est célèbre pour avoir conçu la première version du tableau périodique en 1869 ?', '["Antoine Lavoisier", "Louis Pasteur", "Dmitri Mendeleev", "Marie Curie"]'::jsonb, '["Antoine Lavoisier", "Louis Pasteur", "Dmitri Mendeleïev", "Marie Curie"]'::jsonb, 2, 'Science & Nature', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-c9892ab676f1ee1b', 'The standard periodic table currently contains 118 elements.', 'Le tableau périodique standard comporte actuellement 118 éléments.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Science & Nature', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-f5b844c540f99027', 'All elements in the periodic table are found naturally on Earth.', 'Tous les éléments du tableau périodique se trouvent naturellement sur Terre.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 1, 'Science & Nature', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-e74c7ea3c88dea8a', 'How are the elements in the periodic table ordered?', 'Comment sont classés les éléments dans le tableau périodique ?', '["By increasing atomic number", "Alphabetically", "By melting point", "By discovery date"]'::jsonb, '["Par numéro atomique croissant", "Par ordre alphabétique", "Par point de fusion", "Par date de découverte"]'::jsonb, 0, 'Science & Nature', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-a4010abdeff5527c', 'In chemistry, how many electrons can a ''p'' subshell hold at most?', 'En chimie, combien d''électrons une sous-couche ''p'' peut-elle contenir au maximum ?', '["6", "10", "2", "14"]'::jsonb, '["6", "10", "2", "14"]'::jsonb, 0, 'Science & Nature', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-120c545369ca3bdb', 'To which group of the periodic table does helium belong, despite its specific electronic configuration?', 'À quel groupe du tableau périodique appartient l''hélium, malgré sa configuration électronique particulière ?', '["Group 18", "Group 1", "Group 2", "Group 17"]'::jsonb, '["Groupe 18", "Groupe 1", "Groupe 2", "Groupe 17"]'::jsonb, 0, 'Science & Nature', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-348046866f283441', 'In the periodic table, a period refers to a column of elements.', 'Dans le tableau périodique, une période désigne une colonne d''éléments.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 1, 'Science & Nature', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-86a6378333bd3dd3', 'Which family of metals is known for reacting violently with water to form strong bases?', 'Quelle famille de métaux est connue pour réagir violemment avec l''eau pour former des bases fortes ?', '["Alkali metals", "Halogens", "Noble gases", "Transition metals"]'::jsonb, '["Métaux alcalins", "Halogènes", "Gaz nobles", "Métaux de transition"]'::jsonb, 0, 'Science & Nature', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-e0d97dcb1eb900e2', 'The Klechkowski rule is strictly followed by every single known chemical element.', 'La règle de Klechkowski est scrupuleusement respectée par tous les éléments chimiques connus.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 1, 'Science & Nature', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-a9beea9b03fd49ac', 'What does the term ''Aufbau'' signify in the context of the quantum filling of atomic orbitals?', 'Que signifie le terme ''Aufbau'' dans le contexte du remplissage quantique des orbitales atomiques ?', '["Building up", "Energy loss", "Periodic stability", "Spin pairing"]'::jsonb, '["Édification", "Perte d''énergie", "Stabilité périodique", "Appariement de spin"]'::jsonb, 0, 'Science & Nature', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-a02b95afb3cff805', 'Water is considered a powerful solvent.', 'L''eau est considérée comme un puissant solvant.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Science & Nature', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-5ab0665c3502b460', 'Distilled water maintains a perfectly stable pH of 7 over a long period.', 'L''eau distillée conserve un pH parfaitement stable de 7 sur une longue période.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 1, 'Science & Nature', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-b9ccfa5ecc67a5df', 'What is the approximate angle between the two O-H bonds in a water molecule?', 'Quel est l''angle approximatif entre les deux liaisons O-H dans une molécule d''eau ?', '["120°", "90°", "180°", "104,5°"]'::jsonb, '["120°", "90°", "180°", "104,5°"]'::jsonb, 3, 'Science & Nature', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-49fa7c24d3a5895d', 'What is the approximate percentage of water in the human body of an adult?', 'Quel est le pourcentage approximatif d''eau dans le corps d''un adulte ?', '["95%", "80%", "50%", "65%"]'::jsonb, '["95 %", "80 %", "50 %", "65 %"]'::jsonb, 3, 'Science & Nature', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-043ca445a60ce41c', 'Why does ice float on water?', 'Pourquoi la glace flotte-t-elle sur l''eau ?', '["It contains air bubbles", "It is less dense than liquid water", "It is lighter than water", "It is colder than water"]'::jsonb, '["Elle contient des bulles d''air", "Elle est moins dense que l''eau liquide", "Elle est plus légère que l''eau", "Elle est plus froide que l''eau"]'::jsonb, 1, 'Science & Nature', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-38c805b15ab0a776', 'What are aquaporins, found in cell membranes, responsible for?', 'À quoi servent les aquaporines, présentes dans les membranes cellulaires ?', '["Storing energy for the organism", "Breaking down food molecules", "Allowing water to pass while blocking ions", "Producing oxygen for the cell"]'::jsonb, '["Stocker de l''énergie pour l''organisme", "Décomposer les molécules nutritives", "Laisser passer l''eau tout en bloquant les ions", "Produire de l''oxygène pour la cellule"]'::jsonb, 2, 'Science & Nature', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-03ab9e951c4ced9e', 'Plants are generally composed of more water than animals.', 'Les végétaux sont composés en moyenne de plus d''eau que les animaux.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Science & Nature', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-3e12fcc09b45ce88', 'Liquid water has been formally discovered on the surface of Mars.', 'De l''eau liquide a été formellement découverte à la surface de Mars.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 1, 'Science & Nature', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-d536934cb38f2e2d', 'The Greek prefix ''hydro-'' comes from the word meaning ''water snake''.', 'Le préfixe grec « hydro- » provient du mot signifiant « serpent d''eau ».', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 1, 'Science & Nature', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-43b9e2d81fb48ddd', 'Which two gases are responsible for 90% of human-caused greenhouse gas emissions?', 'Quels sont les deux gaz responsables de 90 % des émissions de gaz à effet de serre d''origine humaine ?', '["Carbon dioxide and methane", "Oxygen and nitrogen", "Helium and hydrogen", "Argon and carbon monoxide"]'::jsonb, '["Le dioxyde de carbone et le méthane", "L''oxygène et l''azote", "L''hélium et l''hydrogène", "L''argon et le monoxyde de carbone"]'::jsonb, 0, 'Science & Nature', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-d81e60ca0b8ea01b', 'The burning of fossil fuels is the primary source of human-caused greenhouse gas emissions.', 'La combustion des énergies fossiles est la source principale des émissions de gaz à effet de serre d''origine humaine.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Science & Nature', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-9bab332208d6db85', 'Which organization labeled climate change as the greatest global health threat of the 21st century?', 'Quelle organisation a désigné le changement climatique comme la plus grande menace pour la santé mondiale au XXIe siècle ?', '["World Health Organization", "Global Health Foundation", "United Nations Environment Programme", "International Climate Agency"]'::jsonb, '["L''Organisation mondiale de la santé", "La Fondation mondiale pour la santé", "Le Programme des Nations unies pour l''environnement", "L''Agence internationale pour le climat"]'::jsonb, 0, 'Science & Nature', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-e17d9975f286b2b7', 'Temperature rise on land is roughly half of the global average temperature increase.', 'L''augmentation de la température sur les terres émergées est environ la moitié de l''augmentation moyenne mondiale.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 1, 'Science & Nature', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-26c4e86e30564487', 'What are the two main strategies for addressing climate change?', 'Quelles sont les deux stratégies principales pour répondre au changement climatique ?', '["Innovation and reforestation", "Mitigation and adaptation", "Regulation and prevention", "Conservation and migration"]'::jsonb, '["L''innovation et le reboisement", "L''atténuation et l''adaptation", "La régulation et la prévention", "La conservation et la migration"]'::jsonb, 1, 'Science & Nature', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-b0b1250380beeccc', 'What term did scientists often use before the 1980s to describe human impact on the climate?', 'Quel terme les scientifiques utilisaient-ils souvent avant les années 1980 pour désigner l''impact humain sur le climat ?', '["Global warming", "Climate emergency", "Inadvertent climate modification", "Atmospheric instability"]'::jsonb, '["Réchauffement climatique", "Urgence climatique", "Modification climatique involontaire", "Instabilité atmosphérique"]'::jsonb, 2, 'Science & Nature', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-a1fb53607a9ed813', 'Which of these natural elements is used by scientists to study past climate variations?', 'Lequel de ces éléments naturels est utilisé par les scientifiques pour étudier les variations climatiques passées ?', '["Desert sand", "Ice cores", "Volcanic lava", "Ocean salt"]'::jsonb, '["Le sable du désert", "Les carottes de glace", "La lave volcanique", "Le sel marin"]'::jsonb, 1, 'Science & Nature', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-875fa609e82939be', 'Where is the vast majority of the excess energy from the climate system stored?', 'Où est stockée la grande majorité du surplus d''énergie du système climatique ?', '["In the oceans", "In the continents", "In polar ice caps", "In the atmosphere"]'::jsonb, '["Dans les océans", "Dans les continents", "Dans les calottes polaires", "Dans l''atmosphère"]'::jsonb, 0, 'Science & Nature', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-88c9e6008e18a30f', 'True or False: The cooling of the upper atmosphere is a sign that greenhouse gases are trapping heat near the Earth''s surface.', 'Vrai ou Faux : Le refroidissement de la haute atmosphère est un signe que les gaz à effet de serre piègent la chaleur près de la surface terrestre.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Science & Nature', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-5123444e61a59519', 'Which region has warmed up significantly faster than the rest of the world?', 'Quelle région s''est réchauffée nettement plus vite que le reste du monde ?', '["The Amazon", "The Arctic", "The Sahara", "The Antarctic"]'::jsonb, '["L''Amazonie", "L''Arctique", "Le Sahara", "L''Antarctique"]'::jsonb, 1, 'Science & Nature', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-62b7c3999f7a3a42', 'True or False: Global land temperatures have increased at about the same speed as global ocean surface temperatures.', 'Vrai ou Faux : Les températures terrestres mondiales ont augmenté à peu près à la même vitesse que les températures de surface des océans.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 1, 'Science & Nature', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-88769970423477f4', 'Which of these is considered an external climate forcing factor?', 'Lequel de ces éléments est considéré comme un facteur de forçage climatique externe ?', '["Urban pollution", "Volcanic eruptions", "Wind currents", "Deforestation"]'::jsonb, '["La pollution urbaine", "Les éruptions volcaniques", "Les courants de vent", "La déforestation"]'::jsonb, 1, 'Science & Nature', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-27d23deb9f929f13', 'Which nickname is commonly given to the planet Mars?', 'Quel est le surnom couramment donné à la planète Mars ?', '["The Blue Planet", "The Dusty Planet", "The Silent Planet", "The Red Planet"]'::jsonb, '["La planète bleue", "La planète poussiéreuse", "La planète silencieuse", "La planète rouge"]'::jsonb, 3, 'Science & Nature', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-ec43fdd8f15b8613', 'Which of these is NOT a terrestrial planet like Mars?', 'Laquelle de ces planètes n''est PAS une planète tellurique comme Mars ?', '["Earth", "Venus", "Mercury", "Jupiter"]'::jsonb, '["Terre", "Vénus", "Mercure", "Jupiter"]'::jsonb, 3, 'Science & Nature', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-7e4129801164157a', 'Mars is currently a planet with very high volcanic and geological activity.', 'Mars est actuellement une planète avec une très forte activité volcanique et géologique.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 1, 'Science & Nature', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-ca359008f7fa4767', 'What substance is primarily responsible for the red color of Mars?', 'Quelle substance est principalement responsable de la couleur rouge de Mars ?', '["Sulfur deposits", "Frozen methane", "Iron oxide", "Copper dust"]'::jsonb, '["Dépôts de soufre", "Méthane gelé", "Oxyde de fer", "Poussière de cuivre"]'::jsonb, 2, 'Science & Nature', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-09d722ffaab514c1', 'About how long does it take for Mars to complete one orbit around the Sun?', 'Environ combien de temps faut-il à Mars pour faire le tour du Soleil ?', '["About 24 hours", "About 687 days", "About 365 days", "About 10 years"]'::jsonb, '["Environ 24 heures", "Environ 687 jours", "Environ 365 jours", "Environ 10 ans"]'::jsonb, 1, 'Science & Nature', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-2b6edfa7923d6b16', 'Mars has an axial tilt (obliquity) that is somewhat similar to Earth''s.', 'L''inclinaison de l''axe de rotation de Mars est assez proche de celle de la Terre.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Science & Nature', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-5975ceb58b0d3fcb', 'Among the eight planets of the Solar System, which one has a more eccentric orbit than Mars?', 'Parmi les huit planètes du Système solaire, laquelle a une orbite plus excentrique que celle de Mars ?', '["Earth", "Mercury", "Jupiter", "Venus"]'::jsonb, '["La Terre", "Mercure", "Jupiter", "Vénus"]'::jsonb, 1, 'Science & Nature', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-c50d0c670a467fba', 'When Mars has high obliquity, ice tends to migrate toward the planet''s poles.', 'Lorsque l''obliquité de Mars est forte, la glace a tendance à migrer vers les pôles de la planète.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 1, 'Science & Nature', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-e1db3ee30d26e923', 'How often do Earth and Mars reach opposition, where they are closest to each other?', 'Tous les combien de jours la Terre et Mars sont-elles en opposition, moment où elles sont les plus proches ?', '["About 365 days", "About 2 years", "About 15 years", "About 780 days"]'::jsonb, '["Environ 365 jours", "Environ 2 ans", "Environ 15 ans", "Environ 780 jours"]'::jsonb, 3, 'Science & Nature', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-434ecf3d1d26f2a0', 'How long is a solar day on Mars?', 'Quelle est la durée d''un jour solaire sur Mars ?', '["About 26 hours and 15 minutes", "About 23 hours and 56 minutes", "Exactly 24 hours", "About 24 hours and 39 minutes"]'::jsonb, '["Environ 26 heures et 15 minutes", "Environ 23 heures et 56 minutes", "Exactement 24 heures", "Environ 24 heures et 39 minutes"]'::jsonb, 3, 'Science & Nature', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-54971487a7bd8e2d', 'Who originally proposed the concept of the Big Bang in 1927?', 'Qui a proposé le concept du Big Bang en 1927 ?', '["Albert Einstein", "Edwin Hubble", "Georges Lemaître", "Fred Hoyle"]'::jsonb, '["Albert Einstein", "Edwin Hubble", "Georges Lemaître", "Fred Hoyle"]'::jsonb, 2, 'Science & Nature', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-021ded5d317d81c1', 'The Big Bang is accurately described as an explosion.', 'Le Big Bang est une explosion de l''Univers.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 1, 'Science & Nature', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-02fa804d578c04a7', 'Who coined the term ''Big Bang'' during a BBC radio broadcast?', 'Qui a inventé l''expression « Big Bang » lors d''une émission de la BBC ?', '["Fred Hoyle", "Edwin Hubble", "Alexandre Friedmann", "Georges Lemaître"]'::jsonb, '["Fred Hoyle", "Edwin Hubble", "Alexandre Friedmann", "Georges Lemaître"]'::jsonb, 0, 'Science & Nature', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-dd6c309921b0e45b', 'Albert Einstein initially believed the Universe was static.', 'Albert Einstein pensait initialement que l''Univers était statique.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Science & Nature', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-ab8208c2bc20cea8', 'Which scientist proposed the expansion of the Universe in 1922, before Georges Lemaître?', 'Quel physicien a proposé l''idée d''expansion de l''Univers en 1922, avant Georges Lemaître ?', '["Fred Hoyle", "Willem de Sitter", "Alexandre Friedmann", "Edwin Hubble"]'::jsonb, '["Fred Hoyle", "Willem de Sitter", "Alexandre Friedmann", "Edwin Hubble"]'::jsonb, 2, 'Science & Nature', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-8a63ff8952ae5e29', 'What discovery in 1965 definitively proved the Big Bang theory?', 'Quelle découverte de 1965 a confirmé la théorie du Big Bang ?', '["Cosmological constant", "Cosmic microwave background", "General relativity", "Extragalactic nebulae"]'::jsonb, '["Constante cosmologique", "Fond diffus cosmologique", "Relativité générale", "Nébuleuses extragalactiques"]'::jsonb, 1, 'Science & Nature', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-e767997be91654c3', 'Which theory is supported by the discovery of the cosmic microwave background?', 'Quelle théorie est confirmée par la découverte du fond diffus cosmologique ?', '["The Steady State theory", "The Multiverse theory", "The Quantum Tunneling theory", "The Big Bang"]'::jsonb, '["La théorie de l''Univers stationnaire", "La théorie du multivers", "La théorie de l''effet tunnel", "Le Big Bang"]'::jsonb, 3, 'Science & Nature', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-b1f3c79c1f6ada86', 'The cosmic microwave background is also known as fossil radiation.', 'Le fond diffus cosmologique est aussi appelé rayonnement fossile.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Science & Nature', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-dc67ce52d3adae85', 'Who are the two scientists who discovered the cosmic microwave background in 1965?', 'Quels sont les deux scientifiques qui ont découvert le fond diffus cosmologique en 1965 ?', '["Lemaître and Gamow", "Friedmann and Einstein", "Penzias and Wilson", "Alpher and Herman"]'::jsonb, '["Lemaître et Gamow", "Friedmann et Einstein", "Penzias et Wilson", "Alpher et Herman"]'::jsonb, 2, 'Science & Nature', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-5cc317cb00bd985d', 'The current temperature of the cosmic microwave background is about 27 degrees Celsius.', 'La température actuelle du fond diffus cosmologique est d''environ 27 degrés Celsius.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 1, 'Science & Nature', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-6ec5858edbb760c5', 'Which element was NOT mentioned as being formed during the primordial phase of the universe?', 'Quel élément n''est pas cité parmi ceux formés durant la phase primordiale de l''Univers ?', '["Carbon", "Hydrogen", "Lithium", "Helium"]'::jsonb, '["Carbone", "Hydrogène", "Lithium", "Hélium"]'::jsonb, 0, 'Science & Nature', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-b232593488121508', 'What percentage of the energy existing as photons in the universe comes from the cosmic microwave background?', 'Quel pourcentage de l''énergie existant sous forme de photons dans l''Univers provient du fond diffus cosmologique ?', '["25%", "4%", "96%", "50%"]'::jsonb, '["25 %", "4 %", "96 %", "50 %"]'::jsonb, 2, 'Science & Nature', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-c126016d7b0de4eb', 'In physics, what is light essentially composed of?', 'En physique, de quoi est constituée la lumière ?', '["Invisible heat vapors", "Microscopic sound particles", "Charged static atoms", "Electromagnetic waves"]'::jsonb, '["Des vapeurs de chaleur invisibles", "Des particules sonores microscopiques", "Des atomes statiques chargés", "Des ondes électromagnétiques"]'::jsonb, 3, 'Science & Nature', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-bb7ad90bbdb7ae8d', 'In a vacuum, how does light travel?', 'Dans le vide, comment la lumière se déplace-t-elle ?', '["In a straight line", "In a circular motion", "In a random wave pulse", "In a zigzag pattern"]'::jsonb, '["En ligne droite", "En suivant un cercle", "Par impulsions aléatoires", "En zigzag"]'::jsonb, 0, 'Science & Nature', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-90178fdac55f653e', 'What is the name of the central part of the retina that allows humans to see colors?', 'Quel est le nom de la zone centrale de la rétine qui permet aux humains de voir les couleurs ?', '["Iris", "Lens", "Cornea", "Fovea"]'::jsonb, '["L''iris", "Le cristallin", "La cornée", "La fovéa"]'::jsonb, 3, 'Science & Nature', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-a5d68ae705df9f60', 'The blue color of the sky is caused by the diffusion of light waves by the air.', 'La couleur bleue du ciel est causée par la diffusion des ondes lumineuses par l''air.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Science & Nature', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-d03d3a8760eb5319', 'Which natural phenomenon is caused by light being decomposed into different wavelengths?', 'Quel phénomène naturel est causé par la décomposition de la lumière selon sa longueur d''onde ?', '["Lightning strike", "Solar eclipse", "Aurora borealis", "Rainbow"]'::jsonb, '["Un éclair", "Une éclipse solaire", "Une aurore boréale", "L''arc-en-ciel"]'::jsonb, 3, 'Science & Nature', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-056366c46255127d', 'What does the letter ''c'' stand for in the physics constant representing the speed of light?', 'Que signifie la lettre « c » dans la constante physique représentant la vitesse de la lumière ?', '["Celerity", "Capacitance", "Constant", "Cycle"]'::jsonb, '["Célérité", "Capacitance", "Constante", "Cycle"]'::jsonb, 0, 'Science & Nature', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-7f6c28142715b95c', 'What term describes two lights that look identical despite having different spectral compositions?', 'Comment appelle-t-on deux lumières perçues comme identiques alors qu''elles ont des compositions spectrales différentes ?', '["Metameric", "Monochromatic", "Isomeric", "Polychromatic"]'::jsonb, '["Métamères", "Monochromatiques", "Isomères", "Polychromatiques"]'::jsonb, 0, 'Science & Nature', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-22985d76bb296baa', 'It is possible for energy to travel faster than the speed of light in a vacuum.', 'Il est possible qu''une énergie se déplace plus vite que la vitesse de la lumière dans le vide.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 1, 'Science & Nature', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-9f88bd784e0d5867', 'The classical law of addition of velocities remains perfectly accurate even at speeds close to the speed of light.', 'La loi classique d''addition des vitesses reste parfaitement exacte, même à des vitesses proches de celle de la lumière.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 1, 'Science & Nature', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-03aa6be00703e3f7', 'In which environment is it impossible for sound to travel?', 'Dans quel milieu est-il impossible au son de se propager ?', '["A vacuum", "Air", "Water", "Steel"]'::jsonb, '["Le vide", "L''air", "L''eau", "L''acier"]'::jsonb, 0, 'Science & Nature', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-4f0381d9b456de42', 'What are the sound vibrations called that have a frequency too high for human hearing?', 'Comment appelle-t-on les vibrations sonores dont la fréquence est trop élevée pour être entendues par l''humain ?', '["Infrasounds", "Ultrasounds", "Megasounds", "Supersounds"]'::jsonb, '["Les infrasons", "Les ultrasons", "Les mégasons", "Les supersons"]'::jsonb, 1, 'Science & Nature', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-ab3b6f259c0f9395', 'When sound travels through a fluid, in which direction do the particles vibrate relative to the wave''s path?', 'Lorsqu''un son se propage dans un fluide, dans quelle direction les particules vibrent-elles par rapport au déplacement de l''onde ?', '["In a circle", "Parallel", "Diagonally", "Perpendicular"]'::jsonb, '["En cercle", "Parallèlement", "En diagonale", "Perpendiculairement"]'::jsonb, 1, 'Science & Nature', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-ea049ad03624944c', 'Psychoacoustics studies how the human body and brain perceive and interpret sounds.', 'La psychoacoustique étudie la manière dont le corps et le cerveau humain perçoivent et interprètent les sons.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Science & Nature', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-e104084fee00dd5f', 'When a sound wave passes through air, the air particles travel long distances along with the wave.', 'Lorsqu''une onde sonore traverse l''air, les particules d''air parcourent de longues distances en suivant l''onde.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 1, 'Science & Nature', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-f7b26a257353d150', 'In which of these materials does sound travel the fastest?', 'Dans lequel de ces matériaux le son se propage-t-il le plus rapidement ?', '["Air", "Steel", "Plastic", "Water"]'::jsonb, '["Air", "Acier", "Plastique", "Eau"]'::jsonb, 1, 'Science & Nature', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-4650f591c049dfcf', 'When watching a thunderstorm, how much time corresponds to a distance of approximately one kilometer for the sound of thunder?', 'Lors d''un orage, quelle durée correspond environ à une distance d''un kilomètre pour le bruit du tonnerre ?', '["1 second", "10 seconds", "3 seconds", "30 seconds"]'::jsonb, '["1 seconde", "10 secondes", "3 secondes", "30 secondes"]'::jsonb, 2, 'Science & Nature', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-050d316be60bb271', 'Humidity has no effect on the speed of sound in the air.', 'L''humidité n''a aucun effet sur la vitesse de propagation du son dans l''air.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 1, 'Science & Nature', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-1a3d5e808bdaa6b2', 'If you are standing downwind from a sound source, how does the wind affect the sound you hear?', 'Si vous vous trouvez sous le vent par rapport à une source sonore, comment le vent affecte-t-il le son que vous entendez ?', '["It has no impact on the sound direction", "It reflects the sound towards the clouds", "It bends the sound towards the ground", "It makes the sound disappear"]'::jsonb, '["Il n''a aucun impact sur la direction du son", "Il renvoie le son vers les nuages", "Il rabat le son vers le sol", "Il fait disparaître le son"]'::jsonb, 2, 'Science & Nature', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-f0cecbb84ba43c23', 'The intensity of a sound decreases as you move further away from the source.', 'L''intensité d''un son diminue à mesure que l''on s''éloigne de la source.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Science & Nature', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-e6013a62850df34b', 'Which physical phenomena are primarily at the base of soundproofing techniques?', 'Quels phénomènes physiques sont principalement à la base de l''isolation phonique ?', '["Acceleration and gravity", "Reflections and refractions", "Magnetism and electricity", "Evaporation and condensation"]'::jsonb, '["Accélération et gravité", "Réflexions et réfractions", "Magnétisme et électricité", "Évaporation et condensation"]'::jsonb, 1, 'Science & Nature', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-6d5d9bbd4defed29', 'What is the primary role of the brain within an organism?', 'Quel est le rôle principal du cerveau au sein d''un organisme ?', '["Producing hormones for digestion only", "Regulating other organ systems and cognitive functions", "Filtering blood to remove toxins", "Storing energy for muscle movement"]'::jsonb, '["Produire des hormones uniquement pour la digestion", "Réguler les autres systèmes d''organes et les fonctions cognitives", "Filtrer le sang pour éliminer les toxines", "Stocker l''énergie pour le mouvement des muscles"]'::jsonb, 1, 'Science & Nature', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-46999b127bafc85d', 'Reflexes require the brain to function properly.', 'Les réflexes nécessitent l''intervention du cerveau pour fonctionner.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 1, 'Science & Nature', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-5bb661e6e310db40', 'What are the long fibers used by neurons to transmit nerve impulses called?', 'Comment appelle-t-on les longues fibres utilisées par les neurones pour transmettre les influx nerveux ?', '["Glial cells", "Neurons", "Synapses", "Axons"]'::jsonb, '["Cellules gliales", "Neurones", "Synapses", "Axones"]'::jsonb, 3, 'Science & Nature', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-06cfd9d586f4854a', 'What was the historical perception of glial cells before the mid-20th century?', 'Quelle était la perception historique des cellules gliales avant le milieu du XXe siècle ?', '["As a type of sensory receptor", "As a glue holding neurons together", "As the primary source of memory", "As the main controllers of movement"]'::jsonb, '["Comme un type de récepteur sensoriel", "Comme une glu maintenant les neurones ensemble", "Comme la source principale de la mémoire", "Comme les contrôleurs principaux du mouvement"]'::jsonb, 1, 'Science & Nature', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-21c1ec0498eefec5', 'Octopuses possess the largest brain among all protostomes.', 'Les pieuvres possèdent le plus gros cerveau parmi tous les protostomiens.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Science & Nature', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-bac6a4d409b83cdf', 'What specific feature helps arthropods process visual information?', 'Quelle structure spécifique aide les arthropodes à traiter les informations visuelles ?', '["A segmented spinal cord", "Large auditory ganglia", "Large optic lobes", "A highly developed cortex"]'::jsonb, '["Une moelle épinière segmentée", "De larges ganglions auditifs", "De larges lobes optiques", "Un cortex très développé"]'::jsonb, 2, 'Science & Nature', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-d581164fab307ee0', 'Which animal was studied by Eric Kandel to understand the molecular basis of memory?', 'Quel animal a été étudié par Eric Kandel pour comprendre les bases moléculaires de la mémoire ?', '["Aplysia", "Nematode worm", "Fruit fly", "Mouse"]'::jsonb, '["L''aplysie", "Le ver nématode", "La drosophile", "La souris"]'::jsonb, 0, 'Science & Nature', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-789e407e67fe0a43', 'How many neurons are found in the nervous system of the C. elegans worm?', 'Combien de neurones possède exactement le système nerveux du ver C. elegans ?', '["102", "802", "502", "302"]'::jsonb, '["102", "802", "502", "302"]'::jsonb, 3, 'Science & Nature', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-965c094365786e32', 'The meninges consist of three membranes: the dura mater, the arachnoid, and the pia mater.', 'Les méninges sont composées de trois membranes : la dure-mère, l''arachnoïde et la pie-mère.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Science & Nature', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-888480091ec01b6c', 'What is the name of the filter that protects the brain from toxins in the blood?', 'Quel est le nom du filtre qui protège le cerveau des toxines contenues dans le sang ?', '["Cerebral membrane", "Meningeal filter", "Blood-brain barrier", "Ventricle wall"]'::jsonb, '["Membrane cérébrale", "Filtre méningé", "Barrière hémato-encéphalique", "Paroi ventriculaire"]'::jsonb, 2, 'Science & Nature', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-986c08712d02ae92', 'Which of these is one of the three initial swellings of the developing brain?', 'Lequel de ces éléments constitue l''un des trois gonflements initiaux du cerveau en développement ?', '["Cerebellum", "Prosencephalon", "Hippocampus", "Neocortex"]'::jsonb, '["Cervelet", "Prosencéphale", "Hippocampe", "Néocortex"]'::jsonb, 1, 'Science & Nature', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-03e82dec4b572bc2', 'Besides a single ventricle, what other structures are part of a mollusk''s heart?', 'En plus d''un ventricule unique, quels éléments composent le cœur des mollusques ?', '["Cones", "Sinus", "Atriums", "Valves"]'::jsonb, '["Des cônes", "Des sinus", "Des oreillettes", "Des valves"]'::jsonb, 2, 'Science & Nature', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-1a1b9caa7291cd0b', 'In vertebrates, the heart is generally positioned on the left side of the body.', 'Chez les vertébrés, le cœur est généralement situé du côté gauche du corps.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Science & Nature', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-e9c90adf8c58ba13', 'In ancient times, Aristotle believed the heart was responsible for pumping blood throughout the body.', 'Dans l''Antiquité, Aristote pensait que le cœur était responsable de la circulation du sang dans le corps.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 1, 'Science & Nature', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-86f03ebab0c5a813', 'Adult amphibians have a heart composed of three cavities.', 'Le cœur des amphibiens adultes est composé de trois cavités.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Science & Nature', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-e0701eaded66811f', 'Which animal group has a heart that completely separates oxygenated and deoxygenated blood?', 'Quel groupe d''animaux possède un cœur séparant totalement le sang oxygéné du sang désoxygéné en permanence ?', '["Fish and amphibians", "Reptiles and amphibians", "Crocodilians and reptiles", "Mammals and birds"]'::jsonb, '["Les poissons et les amphibiens", "Les reptiles et les amphibiens", "Les crocodiliens et les reptiles", "Les mammifères et les oiseaux"]'::jsonb, 3, 'Science & Nature', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-abbfbc26590ad4fa', 'In most terrestrial snakes, the heart is located closer to the head.', 'Chez la plupart des serpents terrestres, le cœur est situé plus proche de la tête.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Science & Nature', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-3ccf78d79f60660f', 'What is the name of the opening found in the heart of crocodilians?', 'Comment s''appelle l''ouverture présente dans le cœur des crocodiliens ?', '["Spiral valve", "Septum interventriculare", "Foramen of Panizza", "Cardiac notch"]'::jsonb, '["Valve spirale", "Septum interventriculaire", "Foramen de Panizza", "Échancrure cardiaque"]'::jsonb, 2, 'Science & Nature', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-76382e4d009e6b0b', 'The human heart is located in the abdominal cavity.', 'Le cœur humain est situé dans la cavité abdominale.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 1, 'Science & Nature', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-24b2fb9465da8fb4', 'What is the name of the membrane that wraps around the heart of mammals and archosaurs?', 'Comment s''appelle la membrane qui enveloppe le cœur des mammifères et des archosauriens ?', '["Mediastinum", "Pericardium", "Septum", "Atrium"]'::jsonb, '["Médiastin", "Péricarde", "Septum", "Atrium"]'::jsonb, 1, 'Science & Nature', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-fe6e60d5d9c42606', 'Which structure in some amphibians helps maintain the separation of blood flows?', 'Quelle structure, chez certains amphibiens, aide à maintenir la séparation des flux sanguins ?', '["Spiral valve", "Interventricular septum", "Foramen of Panizza", "Cardiac notch"]'::jsonb, '["Valve spirale", "Septum interventriculaire", "Foramen de Panizza", "Échancrure cardiaque"]'::jsonb, 0, 'Science & Nature', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-3463f36d433f00e3', 'Which product are honey bees most famous for producing in their hives?', 'Quel produit les abeilles domestiques sont-elles les plus connues pour fabriquer dans leurs ruches ?', '["Royal jelly", "Beeswax", "Honey", "Pollen"]'::jsonb, '["De la gelée royale", "De la cire", "Du miel", "Du pollen"]'::jsonb, 2, 'Science & Nature', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-014b1eb153a7dc10', 'Most bee species live in large, organized social colonies.', 'La majorité des espèces d''abeilles vivent dans de grandes colonies sociales organisées.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 1, 'Science & Nature', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-87a3217b215a727d', 'Where do more than 80% of bee species nest or hibernate?', 'Où nichent ou hivernent plus de 80 % des espèces d''abeilles ?', '["In hives", "In tree hollows", "In rock crevices", "Underground"]'::jsonb, '["Dans des ruches", "Dans des troncs d''arbres", "Dans des fissures de rochers", "Sous terre"]'::jsonb, 3, 'Science & Nature', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-cb843ecb37bc1a11', 'Bumblebees are a specific group of bees.', 'Les bourdons sont un groupe particulier d''abeilles.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Science & Nature', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-b5a229a7e5329c3f', 'From which language did French borrow the word ''abeille''?', 'De quelle langue le français a-t-il emprunté le mot ''abeille'' ?', '["Celtic", "Occitan", "Italian", "Old French"]'::jsonb, '["Le celte", "L''occitan", "L''italien", "L''ancien français"]'::jsonb, 1, 'Science & Nature', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-59133ff007e0e703', 'What is the primary threat to pollinators mentioned as a cause for their decline?', 'Quelle menace principale pesant sur les pollinisateurs est citée comme cause de leur déclin ?', '["Pesticides", "Predators", "Lack of flowers", "Natural aging"]'::jsonb, '["Les pesticides", "Les prédateurs", "Le manque de fleurs", "Le vieillissement naturel"]'::jsonb, 0, 'Science & Nature', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-7965a9e8690af29a', 'From which insect group do scientists believe bees evolved?', 'De quel groupe d''insectes les abeilles descendent-elles selon les scientifiques ?', '["Wasps", "Butterflies", "Ants", "Flies"]'::jsonb, '["Des guêpes", "Des papillons", "Des fourmis", "Des mouches"]'::jsonb, 0, 'Science & Nature', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-f652cafd0266258f', 'To which insect group do bumblebees belong?', 'À quel groupe d''insectes appartiennent les bourdons ?', '["Beetles", "Flies", "Bees", "Wasps"]'::jsonb, '["Aux coléoptères", "Aux mouches", "Aux abeilles", "Aux guêpes"]'::jsonb, 2, 'Science & Nature', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-6933344564287f39', 'The majority of bee species live in colonies.', 'La majorité des espèces d''abeilles vivent en colonie.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 1, 'Science & Nature', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-dacb5113c9aef2f9', 'What is the name of the oldest known bee fossil?', 'Quel est le nom du plus ancien fossile d''abeille connu à ce jour ?', '["Electrapis baltica", "Apis mellifera", "Bombus fossilis", "Melittosphex burmensis"]'::jsonb, '["Electrapis baltica", "Apis mellifera", "Bombus fossilis", "Melittosphex burmensis"]'::jsonb, 3, 'Science & Nature', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-01dc6db397f814d5', 'Wasps are physically distinguished from bees by their thin waist.', 'Les guêpes se distinguent physiquement des abeilles par leur taille fine.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Science & Nature', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-f9da30f5b6bc2844', 'What is the primary role of the bee when moving from flower to flower?', 'Quel est le rôle principal de l''abeille lorsqu''elle vole de fleur en fleur ?', '["Pollination", "Soil aeration", "Seed dispersal", "Fertilization"]'::jsonb, '["La pollinisation", "L''aération du sol", "La dispersion des graines", "La fertilisation"]'::jsonb, 0, 'Science & Nature', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-2d02fcef3feb97e7', 'Which of these terms best describes the role of most sharks in the ocean ecosystem?', 'Quel terme définit le mieux le rôle de la plupart des requins dans l''écosystème marin ?', '["Herbivores", "Predators", "Scavengers", "Decomposers"]'::jsonb, '["Herbivores", "Prédateurs", "Charognards", "Décomposeurs"]'::jsonb, 1, 'Science & Nature', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-384e94c9ddc6413d', 'What does the whale shark mainly feed on despite its massive size?', 'De quoi se nourrit principalement le requin-baleine malgré sa taille imposante ?', '["Seaweed", "Plankton", "Marine mammals", "Small fish"]'::jsonb, '["Algues", "Plancton", "Mammifères marins", "Petits poissons"]'::jsonb, 1, 'Science & Nature', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-d1574a05f6ca4b87', 'It is impossible for any shark species to live in freshwater.', 'Il est impossible pour une espèce de requin de vivre en eau douce.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 1, 'Science & Nature', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-be548aafda62244e', 'Only a small minority of shark species are considered dangerous to humans.', 'Seule une petite minorité d''espèces de requins est considérée comme dangereuse pour l''être humain.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Science & Nature', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-794386c89e8f9ec7', 'What is the primary function of the dermal denticles found on a shark''s skin?', 'Quelle est la fonction principale des denticules dermiques présents sur la peau d''un requin ?', '["Filter seawater", "Attract prey", "Protect against parasites", "Store body fat"]'::jsonb, '["Filtrer l''eau de mer", "Attirer les proies", "Protéger contre les parasites", "Stocker la graisse"]'::jsonb, 2, 'Science & Nature', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-ac2aabb12dd5ac39', 'Which word did the 17th-century etymologist Pierre-Daniel Huet incorrectly link to the origin of the word ''requin''?', 'À quel mot l''étymologiste Pierre-Daniel Huet a-t-il associé, à tort, l''origine du mot « requin » au XVIIe siècle ?', '["Requinquer", "Recherche", "Requérir", "Requiem"]'::jsonb, '["Requinquer", "Recherche", "Requérir", "Requiem"]'::jsonb, 3, 'Science & Nature', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-49de248be75ab9a4', 'What is the skeleton of a shark made of?', 'De quelle matière est constitué le squelette du requin ?', '["Bone", "Ivory", "Chitin", "Cartilage"]'::jsonb, '["Os", "Ivoire", "Chitine", "Cartilage"]'::jsonb, 3, 'Science & Nature', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-4a558a18a6c9e47b', 'Which organ of the shark can represent up to 25% of its total weight?', 'Quel organe du requin peut représenter jusqu''à 25 % de son poids total ?', '["Heart", "Stomach", "Brain", "Liver"]'::jsonb, '["Cœur", "Estomac", "Cerveau", "Foie"]'::jsonb, 3, 'Science & Nature', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-f50a544fac5813cf', 'Historically, sharks were often associated with dogs in ancient languages.', 'Historiquement, les requins étaient souvent associés aux chiens dans les langues anciennes.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Science & Nature', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-3256a18e586e7f38', 'What is the name of the hexagonal calcium salt blocks found on a shark''s jaw?', 'Comment appelle-t-on les minuscules plaques hexagonales de sels de calcium présentes sur la mâchoire du requin ?', '["Crystals", "Denticles", "Scales", "Tessellae"]'::jsonb, '["Cristaux", "Denticules", "Écailles", "Tesselles"]'::jsonb, 3, 'Science & Nature', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-51c983808655bb5e', 'The term ''squale'' comes from a Latin word meaning ''the smooth one''.', 'Le terme « squale » vient d''un mot latin signifiant « le lisse ».', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 1, 'Science & Nature', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-12068f6e2a726471', 'Which of these is a common name for a type of shark that does not contain the word ''shark''?', 'Lequel de ces noms désigne un type de requin sans utiliser le mot « requin » ?', '["Tiger", "Hammerhead", "Mako", "Great White"]'::jsonb, '["Tigre", "Marteau", "Mako", "Grand blanc"]'::jsonb, 2, 'Science & Nature', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-6a3261dfe97cc544', 'What is the specific name for a baby whale?', 'Comment appelle-t-on le petit de la baleine ?', '["A pup", "A foal", "A calf", "A cub"]'::jsonb, '["Un chiot", "Un poulain", "Un baleineau", "Un louveteau"]'::jsonb, 2, 'Science & Nature', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-ce7c0e32eeaf3de3', 'Ancient Greeks and Romans knew that whales were mammals, not fish.', 'Les anciens Grecs et Romains savaient que les baleines étaient des mammifères et non des poissons.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Science & Nature', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-6fba8b942fc5c4a0', 'In French, which of these animals is NOT considered a whale, despite being sometimes called a ''killer whale''?', 'En français, quel animal n''est pas une baleine, bien qu''il soit parfois surnommé « baleine tueuse » ?', '["The humpback whale", "The sperm whale", "The orca", "The blue whale"]'::jsonb, '["La baleine à bosse", "Le cachalot", "L''orque", "La baleine bleue"]'::jsonb, 2, 'Science & Nature', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-ef77a725e7849e99', 'The French city of Sète is named after the word for whale in ancient Greek.', 'La ville de Sète doit son nom au mot désignant la baleine en grec ancien.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 1, 'Science & Nature', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-1854efe82988a351', 'To which biological family do ''beaked whales'' belong?', 'À quelle famille biologique appartiennent les « baleines à bec » ?', '["Ziphiidae", "Monodontidae", "Balaenidae", "Delphinidae"]'::jsonb, '["Ziphiidae", "Monodontidae", "Balaenidae", "Delphinidae"]'::jsonb, 0, 'Science & Nature', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-b6c3edda42eed1f4', 'Why are whale carcasses important for the deep-sea ecosystem?', 'Pourquoi les cadavres de baleines sont-ils importants pour l''écosystème des grands fonds ?', '["They regulate sea temperature", "They oxygenate the water", "They provide a rich source of nutrients", "They create underwater reefs"]'::jsonb, '["Ils régulent la température marine", "Ils oxygènent l''eau", "Ils sont une riche source de nutriments", "Ils créent des récifs coralliens"]'::jsonb, 2, 'Science & Nature', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-0acd248bb5086c1e', 'What is the primary food source of most whales?', 'Quelle est la nourriture principale des baleines ?', '["Zooplankton", "Coral", "Seaweed", "Small fish"]'::jsonb, '["Le zooplancton", "Du corail", "Des algues marines", "Des petits poissons"]'::jsonb, 0, 'Science & Nature', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-61e680bf0be3f622', 'Whales are considered natural carbon sinks.', 'Les baleines sont considérées comme des puits de carbone naturels.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Science & Nature', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-4bfba7767c172cf7', 'Approximately how much CO2 is sequestered when a whale dies and sinks to the ocean floor?', 'Environ combien de CO2 est séquestré lorsqu''une baleine meurt et coule au fond de l''océan ?', '["33 tonnes", "3 tonnes", "133 tonnes", "330 tonnes"]'::jsonb, '["33 tonnes", "3 tonnes", "133 tonnes", "330 tonnes"]'::jsonb, 0, 'Science & Nature', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-a42457da40459591', 'Japan and Norway are two countries that have strictly respected all whaling moratoriums.', 'Le Japon et la Norvège sont deux pays ayant strictement respecté tous les moratoires sur la chasse à la baleine.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 1, 'Science & Nature', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-a5c52aae529acc3b', 'Which part of the whale was historically used to produce oil?', 'Quelle partie de la baleine était historiquement utilisée pour produire de l''huile ?', '["Skin", "Bones", "Fat", "Baleen"]'::jsonb, '["La peau", "Les os", "La graisse", "Les fanons"]'::jsonb, 2, 'Science & Nature', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-f9b7075687c1630b', 'What happens to the ocean floor environment when a whale skeleton decomposes?', 'Que devient l''environnement du fond marin lors de la décomposition du squelette d''une baleine ?', '["It becomes a biodiversity hotspot", "It becomes toxic and barren", "It creates a volcanic vent", "It attracts only scavengers"]'::jsonb, '["Il devient un point chaud de biodiversité", "Il devient toxique et stérile", "Il crée une source volcanique", "Il n''attire que des charognards"]'::jsonb, 0, 'Science & Nature', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-254ebf8c4973279d', 'Which of these plants is typically found in tropical forests?', 'Laquelle de ces plantes trouve-t-on traditionnellement dans les forêts tropicales ?', '["Cocoa tree", "Apple tree", "Potato", "Wheat"]'::jsonb, '["Cacaoyer", "Pommier", "Pomme de terre", "Blé"]'::jsonb, 0, 'Science & Nature', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-4f63a25fb691de4b', 'Which French overseas territory is home to the largest tropical forest?', 'Quel territoire français d''outre-mer abrite la plus grande forêt tropicale ?', '["Réunion", "Martinique", "Guadeloupe", "French Guiana"]'::jsonb, '["Réunion", "Martinique", "Guadeloupe", "Guyane"]'::jsonb, 3, 'Science & Nature', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-3278479153c247bf', 'Sustainable logging can be a tool for forest conservation.', 'L''exploitation forestière durable peut être un outil de conservation des forêts.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Science & Nature', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-1e26f0a42b6d024e', 'How is the forest of French Guiana partially protected?', 'Comment la forêt de Guyane est-elle partiellement protégée ?', '["By nature reserves and a national park", "By a strictly private commercial management", "By a total ban on all human access", "By an international wall surrounding the area"]'::jsonb, '["Par des réserves naturelles et un parc national", "Par une gestion commerciale strictement privée", "Par une interdiction totale d''accès humain", "Par un mur international entourant la zone"]'::jsonb, 0, 'Science & Nature', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-e7260a0b5763487a', 'Tropical forests are exclusively made of deciduous trees.', 'Les forêts tropicales sont exclusivement composées d''arbres à feuilles caduques.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 1, 'Science & Nature', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-24d76f7cac4cc8f3', 'Which organization is NOT mentioned as studying the forests of French Guiana?', 'Quelle organisation n''est PAS mentionnée comme étudiant les forêts de Guyane ?', '["INRA", "CNRS", "UNESCO", "ONF"]'::jsonb, '["INRA", "CNRS", "UNESCO", "ONF"]'::jsonb, 2, 'Science & Nature', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-a5a79cfbdfd4b9a5', 'What is the name of a scientific station located in the French Guiana forest?', 'Quel est le nom d''une station scientifique située dans la forêt guyanaise ?', '["Saint-Georges", "Saint-Élie", "Saint-Laurent", "Saint-Eugène"]'::jsonb, '["Saint-Georges", "Saint-Élie", "Saint-Laurent", "Saint-Eugène"]'::jsonb, 3, 'Science & Nature', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-1705b2b3d53dc5b9', 'What is the approximate size ratio between an atom and its nucleus?', 'Quel est le rapport de taille approximatif entre un atome et son noyau ?', '["100 times", "1 000 times", "1 000 000 times", "40 000 times"]'::jsonb, '["100 fois", "1 000 fois", "1 000 000 fois", "40 000 fois"]'::jsonb, 3, 'Science & Nature', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-b4eb3ff189653549', 'Approximately what percentage of an atom''s total mass is concentrated in its nucleus?', 'Quel pourcentage environ de la masse totale d''un atome est concentré dans son noyau ?', '["About 50%", "About 90%", "About 75%", "More than 99.9%"]'::jsonb, '["Environ 50 %", "Environ 90 %", "Environ 75 %", "Plus de 99,9 %"]'::jsonb, 3, 'Science & Nature', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-24db62c0309572d7', 'The word ''atom'' comes from a Greek term meaning ''divisible''.', 'Le mot « atome » vient d''un terme grec qui signifie « divisible ».', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 1, 'Science & Nature', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-9f6929bc1a1e090c', 'Lead-208 is currently considered the heaviest stable isotope.', 'Le plomb 208 est considéré comme l''isotope stable le plus lourd.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Science & Nature', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-8d797c1f12eaa613', 'Humanity has been able to directly observe atoms since Antiquity.', 'L''humanité est capable d''observer directement les atomes depuis l''Antiquité.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 1, 'Science & Nature', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-83f00b213518e91a', 'Which combination of quarks forms a neutron?', 'Quelle combinaison de quarks constitue un neutron ?', '["One up quark and two down quarks", "Two up quarks and one down quark", "Three up quarks", "Three down quarks"]'::jsonb, '["Un quark up et deux quarks down", "Deux quarks up et un quark down", "Trois quarks up", "Trois quarks down"]'::jsonb, 0, 'Science & Nature', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-d542473b4ae22abc', 'To which category of particles do electrons belong?', 'À quelle catégorie de particules appartiennent les électrons ?', '["Leptons", "Gluons", "Baryons", "Bosons"]'::jsonb, '["Leptons", "Gluons", "Baryons", "Bosons"]'::jsonb, 0, 'Science & Nature', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-0cc967e582bb640b', 'The Schrödinger model describes the electron exclusively as a particle.', 'Le modèle de Schrödinger décrit l''électron exclusivement comme une particule.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 1, 'Science & Nature', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-63160c879fba16b3', 'A neutron is more massive than an electron.', 'Un neutron est plus massif qu''un électron.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Science & Nature', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-83762b9c923b6599', 'Which of these is a nitrogenous base found in DNA?', 'Parmi les suivantes, quelle est une base azotée présente dans l''ADN ?', '["Valine", "Leucine", "Glycine", "Cytosine"]'::jsonb, '["Valine", "Leucine", "Glycine", "Cytosine"]'::jsonb, 3, 'Science & Nature', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-57b5def5cc9c5d53', 'In prokaryotic cells like bacteria, DNA is contained within a nucleus.', 'Chez les cellules procaryotes comme les bactéries, l''ADN est contenu à l''intérieur d''un noyau.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 1, 'Science & Nature', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-25442767b997579f', 'Which proteins play a key role in compacting DNA into chromosomes?', 'Quelles protéines jouent un rôle clé dans la compaction de l''ADN en chromosomes ?', '["Keratins", "Collagens", "Histones", "Insulins"]'::jsonb, '["Kératines", "Collagènes", "Histones", "Insulines"]'::jsonb, 2, 'Science & Nature', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-b3b31fcec5d1d8f4', 'Peptides and carbohydrates are considered biopolymers, just like nucleic acids.', 'Les peptides et les glucides sont considérés comme des biopolymères, au même titre que les acides nucléiques.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Science & Nature', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-7032f2ba7babc7ac', 'Which genetic disease is caused by the modification of a single base in the hemoglobin gene?', 'Quelle maladie génétique est causée par la modification d''une seule base dans le gène de l''hémoglobine ?', '["Hemophilia", "Huntington''s disease", "Sickle cell anemia", "Cystic fibrosis"]'::jsonb, '["Hémophilie", "Maladie de Huntington", "Drépanocytose", "Mucoviscidose"]'::jsonb, 2, 'Science & Nature', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-4b98dd515c622c33', 'What do you get when you add one to three phosphate groups to a nucleoside?', 'Qu''obtient-on en ajoutant un à trois groupes phosphate à un nucléoside ?', '["A base pair", "A double helix", "An amino acid", "A nucleotide"]'::jsonb, '["Une paire de bases", "Une double hélice", "Un acide aminé", "Un nucléotide"]'::jsonb, 3, 'Science & Nature', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-761544a4528a09bc', 'Which base is found in DNA but is replaced by uracil in some viruses?', 'Quelle base est présente dans l''ADN mais remplacée par l''uracile chez certains virus ?', '["Cytosine", "Adenine", "Guanine", "Thymine"]'::jsonb, '["Cytosine", "Adénine", "Guanine", "Thymine"]'::jsonb, 3, 'Science & Nature', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-9e5682458c36a5f9', 'The sugar found in the backbone of DNA is ribose.', 'Le sucre présent dans le squelette de l''ADN est le ribose.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 1, 'Science & Nature', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-0ff1de32719f67f9', 'The two strands of a DNA double helix are described as antiparallel.', 'Les deux brins d''une double hélice d''ADN sont dits antiparallèles.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Science & Nature', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-7d1b03efb8778a46', 'The comparison of the Big Bang to a giant explosion is scientifically accurate.', 'La comparaison du Big Bang avec une explosion géante est scientifiquement exacte.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 1, 'Science & Nature', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-bb27c632c9c8fbd0', 'What principle stipulates that the Universe is homogeneous and isotropic, meaning humans occupy no privileged position?', 'Quel principe stipule que l''Univers est homogène et isotrope, signifiant que l''Homme n''occupe aucune position privilégiée ?', '["Relativity principle", "Steady state principle", "Cosmological principle", "Expansion principle"]'::jsonb, '["Principe de relativité", "Principe d''état stationnaire", "Principe cosmologique", "Principe d''expansion"]'::jsonb, 2, 'Science & Nature', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-c28a455ebd1308d8', 'Which specific type of electromagnetic radiation corresponds to the cosmic microwave background?', 'Quel type de rayonnement électromagnétique correspond au fond diffus cosmologique ?', '["Gamma ray", "Ultraviolet", "Microwave", "X-ray"]'::jsonb, '["Rayons gamma", "Ultraviolet", "Micro-ondes", "Rayons X"]'::jsonb, 2, 'Science & Nature', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-d909816c0a94b766', 'According to the Big Bang model, the Universe was significantly colder in its past.', 'Selon le modèle du Big Bang, l''Univers était beaucoup plus froid par le passé.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 1, 'Science & Nature', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-34cfcc6c6ae91ffd', 'Georges Lemaître is considered one of the first scientists to suggest that the Universe was hotter in the past.', 'Georges Lemaître est considéré comme l''un des premiers scientifiques à avoir suggéré que l''Univers était plus chaud par le passé.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Science & Nature', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-e3eaeae6711645f4', 'Which chemical element is NOT listed as one of the light elements whose abundance serves as a proof for the Big Bang?', 'Quel élément chimique ne fait pas partie des éléments légers dont l''abondance sert de preuve au Big Bang ?', '["Carbon", "Helium", "Lithium", "Hydrogen"]'::jsonb, '["Carbone", "Hélium", "Lithium", "Hydrogène"]'::jsonb, 0, 'Science & Nature', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-df1523d79161c4af', 'Until the mid-20th century, what were glial cells commonly believed to be?', 'Jusqu''au milieu du XXe siècle, pour quoi prenaient-on les cellules gliales ?', '["A type of sensory neuron", "A layer of protective fat", "Empty spaces in the brain", "A glue holding neurons together"]'::jsonb, '["Un type de neurone sensoriel", "Une couche de graisse protectrice", "Des espaces vides cérébraux", "Une glu reliant les neurones"]'::jsonb, 3, 'Science & Nature', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-969209b8539c0ee8', 'Which of these functions does NOT require the brain''s intervention?', 'Lequel de ces phénomènes ne nécessite pas l''intervention du cerveau ?', '["Cognitive functions", "Sophisticated behaviors", "Sensory information processing", "Reflexes"]'::jsonb, '["Les fonctions cognitives", "Les comportements sophistiqués", "Le traitement sensoriel", "Les réflexes"]'::jsonb, 3, 'Science & Nature', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-23bd468621817c7d', 'What is the name of the long protoplasmic fibers neurons use to communicate?', 'Comment nomme-t-on les longues fibres protoplasmiques permettant aux neurones de communiquer ?', '["Axons", "Neural synapses", "Cerebral nodes", "Glial filaments"]'::jsonb, '["Les axones", "Synapses neuronales", "Nœuds cérébraux", "Filaments gliaux"]'::jsonb, 0, 'Science & Nature', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-e0495798504e906e', 'The evolutionary approach assumes that brain traits found in all descendants were absent in their common ancestor.', 'L''approche évolutionniste suppose que les traits cérébraux retrouvés chez tous les descendants étaient absents de leur ancêtre commun.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 1, 'Science & Nature', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-3f64b8318b344331', 'Which of these is NOT one of the three membranes that make up the meninges?', 'Laquelle de ces membranes ne fait PAS partie des trois couches composant les méninges ?', '["The dura-arachnoid", "Pia mater", "Dura mater", "Arachnoid"]'::jsonb, '["La dure-arachnoïde", "La pie-mère", "La dure-mère", "L''arachnoïde"]'::jsonb, 0, 'Science & Nature', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-7b229eaa0b514d95', 'The meninges are a system of connective tissue membranes that protect the brain.', 'Les méninges sont un système de membranes en tissu conjonctif qui protège le cerveau.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Science & Nature', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-cfa71fdf50c15b75', 'In mammals, the prosencephalon is a smaller brain region than the mesencephalon.', 'Chez les mammifères, le prosencéphale est une région du cerveau plus petite que le mésencéphale.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 1, 'Science & Nature', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-f88132b385eb3016', 'What does the acronym LUCA stand for in the context of biological evolution?', 'Que signifie l''acronyme LUCA dans le contexte de l''évolution biologique ?', '["Last Universal Common Ancestor", "Life Universal Cellular Ancestor", "Last Unique Created Ancestor", "Late Universal Core Ancestor"]'::jsonb, '["Dernier ancêtre commun universel", "Lignée universelle cellulaire ancienne", "L''unique créateur ancestral", "L''ancêtre commun universellement limité"]'::jsonb, 0, 'Science & Nature', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-a5dff97236d87bbd', 'Which scientist first formulated a transformist theory based on the complexification of organisms and adaptive diversification?', 'Quel scientifique a formulé la première théorie transformiste basée sur la complexification des organismes et la diversification adaptative ?', '["August Weismann", "Gregor Mendel", "Charles Darwin", "Jean-Baptiste de Lamarck"]'::jsonb, '["August Weismann", "Gregor Mendel", "Charles Darwin", "Jean-Baptiste de Lamarck"]'::jsonb, 3, 'Science & Nature', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-84d37d98151d00f8', 'What scientific discovery by August Weismann in 1883 rendered the transmission of acquired characteristics impossible?', 'Quelle découverte scientifique d''August Weismann en 1883 a rendu impossible la transmission des caractères acquis ?', '["Separation of germ and somatic lineages", "Natural selection of species", "Mutation of genetic codes", "Discovery of DNA double helix"]'::jsonb, '["Séparation des lignées germinale et somatique", "Sélection naturelle des espèces", "Mutation des codes génétiques", "Découverte de la double hélice d''ADN"]'::jsonb, 0, 'Science & Nature', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-b6f9a27a8676754b', 'Charles Darwin completely rejected the Lamarckian mechanisms of transmission of acquired characteristics.', 'Charles Darwin rejetait totalement les mécanismes lamarckiens de transmission des caractères acquis.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 1, 'Science & Nature', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-a7786581cbccac2d', 'An evolutionary tree representing the history of species is called a phylogenetic tree.', 'Un arbre retraçant l''histoire des espèces est appelé un arbre phylogénétique.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Science & Nature', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-1de81826d4226395', 'Which of these is a mechanism discovered after 1950 that helps explain genetic evolution?', 'Lequel de ces mécanismes découverts après 1950 aide à expliquer l''évolution génétique ?', '["Natural selection", "Endosymbiosis", "Adaptive diversification", "Transformism"]'::jsonb, '["Sélection naturelle", "Endosymbiose", "Diversification adaptative", "Transformisme"]'::jsonb, 1, 'Science & Nature', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-82eefb00672aa845', 'To define ''natural selection'', Charles Darwin drew a parallel with the selection methods used by which group?', 'Pour définir la ''sélection naturelle'', Charles Darwin a fait un parallèle avec les méthodes de sélection pratiquées par quel groupe ?', '["Doctors and surgeons", "Philosophers and theologians", "Farmers and breeders", "Naturalists and geologists"]'::jsonb, '["Les médecins et chirurgiens", "Les philosophes et théologiens", "Les agriculteurs et éleveurs", "Les naturalistes et géologues"]'::jsonb, 2, 'Science & Nature', 'easy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-42ed0522a0fb7888', 'Which of these two elements is liquid at standard temperature and pressure?', 'Parmi ces éléments, lesquels sont liquides dans les conditions normales de température et de pression ?', '["Gallium and cesium", "Francium and rubidium", "Technetium and plutonium", "Bromine and mercury"]'::jsonb, '["Le gallium et le césium", "Le francium et le rubidium", "Le technétium et le plutonium", "Le brome et le mercure"]'::jsonb, 3, 'Science & Nature', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-a6da5e3f7ad50171', 'There are exactly 118 primordial elements in the periodic table.', 'Il existe exactement 118 éléments primordiaux dans le tableau périodique.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 1, 'Science & Nature', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-22704c75d410f628', 'Which letters are used to designate the four types of electron subshells in the periodic table?', 'Quelles lettres désignent les quatre types de sous-couches électroniques dans le tableau périodique ?', '["k, l, m, n", "a, b, c, d", "s, p, d, f", "x, y, z, w"]'::jsonb, '["k, l, m, n", "a, b, c, d", "s, p, d, f", "x, y, z, w"]'::jsonb, 2, 'Science & Nature', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-1a9be1f19ac02bee', 'Bismuth is one of the three primordial elements that are radioactive.', 'Le bismuth fait partie des trois éléments primordiaux qui sont radioactifs.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Science & Nature', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-f95e32096234606c', 'What is the name given to each horizontal row in the periodic table?', 'Comment appelle-t-on chaque ligne horizontale du tableau périodique ?', '["Period", "Group", "Block", "Family"]'::jsonb, '["Une période", "Un groupe", "Un bloc", "Une famille"]'::jsonb, 0, 'Science & Nature', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-124eb9b74902e4f3', 'What are the two possible values for the magnetic spin quantum number of an electron?', 'Quelles sont les deux valeurs possibles pour le nombre quantique magnétique de spin d''un électron ?', '["-1/2 and +1/2", "0 and 1", "-1 and 1", "1/4 and 3/4"]'::jsonb, '["-1/2 et +1/2", "0 et 1", "-1 et 1", "1/4 et 3/4"]'::jsonb, 0, 'Science & Nature', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-7cdd54f90b6857ec', 'What is the maximum number of electrons that can fit into a ''d'' subshell?', 'Quel est le nombre maximal d''électrons pouvant occuper une sous-couche électronique de type ''d'' ?', '["10", "6", "14", "2"]'::jsonb, '["10", "6", "14", "2"]'::jsonb, 0, 'Science & Nature', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-b97bbddcc4c7b067', 'In which column of the periodic table is helium usually placed due to its chemical properties?', 'Dans quelle colonne le tableau périodique place-t-il usuellement l''hélium en raison de ses propriétés chimiques ?', '["17", "2", "1", "18"]'::jsonb, '["17", "2", "1", "18"]'::jsonb, 3, 'Science & Nature', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-99664222a59704c1', 'The order of filling electron subshells is determined by the Klechkowski rule using the values of n and ℓ.', 'L''ordre de remplissage des sous-couches électroniques est déterminé par la règle de Klechkowski en utilisant les valeurs de n et ℓ.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 0, 'Science & Nature', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-259ac1cdf458f5ea', 'Alkali metals are stable enough to be found in their elemental form in nature.', 'Les métaux alcalins sont suffisamment stables pour être trouvés sous forme élémentaire dans le milieu naturel.', '["True", "False"]'::jsonb, '["Vrai", "Faux"]'::jsonb, 1, 'Science & Nature', 'medium', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-1ca978b9cfaf495e', 'Which group of the periodic table is historically known as the pnictogens?', 'Quel groupe du tableau périodique est historiquement désigné sous le nom de pnictogènes ?', '["1", "2", "15", "17"]'::jsonb, '["1", "2", "15", "17"]'::jsonb, 2, 'Science & Nature', 'hard', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'gen-fc39deef96320bdc', 'Which scientist''s rule states that a higher resulting spin of electrons in an orbital makes the configuration more stable?', 'Selon la règle de quel scientifique, une configuration électronique est plus stable si le spin résultant des électrons est élevé ?', '["Hund", "Klechkowski", "Aufbau", "Pauli"]'::jsonb, '["Hund", "Klechkowski", "Aufbau", "Pauli"]'::jsonb, 0, 'Science & Nature', 'hard', CURRENT_TIMESTAMP)
ON CONFLICT DO NOTHING;

INSERT INTO "Tag" ("id", "slug", "createdAt") VALUES
    (gen_random_uuid()::text, 'anatomie', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'assassins-creed', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'astronomie', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'biologie', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'chimie', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'cinema', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'crash-bandicoot', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'entreprise', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'final-fantasy', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'fortnite', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'histoire', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'james-bond', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'jeu', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'just-dance', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'league-of-legends', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'les-sims', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'lieu', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'lord-of-the-rings', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'mario', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'minecraft', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'musique', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'nintendo', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'pac-man', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'pokemon', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'rayman', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'rocket-league', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'rockstar-games', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'rome', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'science', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'sega', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'sony', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'street-fighter', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'television', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'tetris', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'trackmania', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'unesco', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'world-of-warcraft', CURRENT_TIMESTAMP),
    (gen_random_uuid()::text, 'zelda', CURRENT_TIMESTAMP)
ON CONFLICT ("slug") DO NOTHING;

INSERT INTO "_QuestionToTag" ("A", "B")
SELECT q."id", t."id" FROM (VALUES
    ('gen-7f7609e54bfb598b', 'mario'),
    ('gen-7f7609e54bfb598b', 'nintendo'),
    ('gen-7f7609e54bfb598b', 'zelda'),
    ('gen-b91aa5080a6134cc', 'zelda'),
    ('gen-977848fc1cd64b4f', 'zelda'),
    ('gen-01ef47690a59916b', 'zelda'),
    ('gen-ac47febedeba08ad', 'zelda'),
    ('gen-ae92dfc945b669bb', 'zelda'),
    ('gen-6bdb066e8f51dec4', 'nintendo'),
    ('gen-6bdb066e8f51dec4', 'pokemon'),
    ('gen-a9101f8930ba4a4d', 'pokemon'),
    ('gen-6e7279ef39ef63e1', 'pokemon'),
    ('gen-7ac2edba1b96a5f5', 'pokemon'),
    ('gen-dd53472fa6f016d8', 'pokemon'),
    ('gen-23fc3621e55961fa', 'nintendo'),
    ('gen-23fc3621e55961fa', 'pokemon'),
    ('gen-8c2d48015ffdd937', 'nintendo'),
    ('gen-8c2d48015ffdd937', 'pokemon'),
    ('gen-43a97bf631867994', 'nintendo'),
    ('gen-43a97bf631867994', 'pokemon'),
    ('gen-5e250fe587089738', 'nintendo'),
    ('gen-5e250fe587089738', 'pokemon'),
    ('gen-1d7e35a0b55a3292', 'mario'),
    ('gen-1d7e35a0b55a3292', 'nintendo'),
    ('gen-b84b755a567bf8ca', 'nintendo'),
    ('gen-cd4d0170fbd97efe', 'mario'),
    ('gen-cd4d0170fbd97efe', 'nintendo'),
    ('gen-638998fb2cbfae7c', 'nintendo'),
    ('gen-c9c7bb094ded2606', 'sony'),
    ('gen-27f8a2a00d0d62a3', 'nintendo'),
    ('gen-27f8a2a00d0d62a3', 'sony'),
    ('gen-13ed0950b38e3983', 'sega'),
    ('gen-cd82c9201d660229', 'sony'),
    ('gen-235112adc11bbf5c', 'sony'),
    ('gen-a2ad9d56dfd80c0a', 'crash-bandicoot'),
    ('gen-5c1fe10964e380a5', 'sega'),
    ('gen-5c1fe10964e380a5', 'sony'),
    ('gen-b95781e98113b631', 'sega'),
    ('gen-b95781e98113b631', 'sony'),
    ('gen-573b58e169316130', 'sony'),
    ('gen-46b07bff0d0ee418', 'nintendo'),
    ('gen-3ba05373249ecc67', 'sony'),
    ('gen-d8e51e4d8ba404e6', 'minecraft'),
    ('gen-992dd075f07680f9', 'minecraft'),
    ('gen-8fd87fa114ba5318', 'minecraft'),
    ('gen-0479eb388a5e1e59', 'minecraft'),
    ('gen-406e919f8ef28c41', 'minecraft'),
    ('gen-76dd3a46244ecb6d', 'minecraft'),
    ('gen-fa69e4511eab9c01', 'entreprise'),
    ('gen-8df65c17bff3666f', 'musique'),
    ('gen-23d1861a77719338', 'fortnite'),
    ('gen-55e526f01561665a', 'fortnite'),
    ('gen-55e526f01561665a', 'minecraft'),
    ('gen-e799ea9b8a829a32', 'fortnite'),
    ('gen-e799ea9b8a829a32', 'rocket-league'),
    ('gen-fd0bae255ed3c48e', 'fortnite'),
    ('gen-006df90be06a286c', 'fortnite'),
    ('gen-b603db75aacb1720', 'rockstar-games'),
    ('gen-7406a22a97c795a6', 'rockstar-games'),
    ('gen-131e144bbebd76e8', 'rockstar-games'),
    ('gen-ae7257ae05395f86', 'rockstar-games'),
    ('gen-c2289ad9a485d29c', 'rockstar-games'),
    ('gen-b885427b86331688', 'rockstar-games'),
    ('gen-27d9e107c332e8de', 'rockstar-games'),
    ('gen-9d74c2cf69296880', 'rockstar-games'),
    ('gen-8117a3eb4893b897', 'rockstar-games'),
    ('gen-54ef73a0efc76ad8', 'rockstar-games'),
    ('gen-c3670ebba87b5e19', 'rockstar-games'),
    ('gen-6e2992680d2eb735', 'rockstar-games'),
    ('gen-556b47227c597a3f', 'tetris'),
    ('gen-c82fca4fe8fc0d1b', 'tetris'),
    ('gen-93a5858c12361a4b', 'tetris'),
    ('gen-4ecc351df2517268', 'tetris'),
    ('gen-32fb051a5f5b347c', 'tetris'),
    ('gen-97454c163c6319da', 'tetris'),
    ('gen-6c9b6524f51c07fd', 'tetris'),
    ('gen-bc58f94580e9d9a0', 'tetris'),
    ('gen-51c98a76e03ffb50', 'tetris'),
    ('gen-f2d52c3c14b9476d', 'nintendo'),
    ('gen-f2d52c3c14b9476d', 'tetris'),
    ('gen-782b4042365b844a', 'tetris'),
    ('gen-a64e8bd11d5907d4', 'pac-man'),
    ('gen-17db84b0b102e675', 'pac-man'),
    ('gen-afeb0ac1c4d7b7e0', 'pac-man'),
    ('gen-9a51be1e19651250', 'pac-man'),
    ('gen-01bcf454626e952e', 'pac-man'),
    ('gen-84274209e318e71d', 'pac-man'),
    ('gen-7c9bea98f60f049e', 'pac-man'),
    ('gen-fa906e77c8e2e59f', 'pac-man'),
    ('gen-c10f010c230f8e61', 'pac-man'),
    ('gen-078c4f13c76037c9', 'pac-man'),
    ('gen-136e97b2b0133444', 'pac-man'),
    ('gen-1664de10433f22dc', 'street-fighter'),
    ('gen-2b806cff227d9804', 'street-fighter'),
    ('gen-9535a554c32a71e7', 'cinema'),
    ('gen-5ebc1cc6b63fe1e7', 'street-fighter'),
    ('gen-8a56d45f5d0fc30b', 'cinema'),
    ('gen-8a56d45f5d0fc30b', 'street-fighter'),
    ('gen-7aa34418c248ce0e', 'entreprise'),
    ('gen-b3ac031df9cc4576', 'jeu'),
    ('gen-e4167aeec29ee802', 'jeu'),
    ('gen-b9ae0311a2df17af', 'jeu'),
    ('gen-90eac131e412f704', 'jeu'),
    ('gen-80fbb55926776e63', 'les-sims'),
    ('gen-ea265db666f0eb1b', 'les-sims'),
    ('gen-4618bb7441610eea', 'les-sims'),
    ('gen-7d5809b93abf9fe5', 'les-sims'),
    ('gen-d73e92567847f4b8', 'les-sims'),
    ('gen-4d51551173565aed', 'assassins-creed'),
    ('gen-2913c3c044662510', 'assassins-creed'),
    ('gen-6e538c1b15ea9ee6', 'assassins-creed'),
    ('gen-b4e56f611a4eb87e', 'assassins-creed'),
    ('gen-5d38eaceff27ec25', 'assassins-creed'),
    ('gen-a58c71c7984e834c', 'assassins-creed'),
    ('gen-7de75f1f906b71a2', 'assassins-creed'),
    ('gen-cac15e49d40ec499', 'assassins-creed'),
    ('gen-e4c3203ec983386b', 'rayman'),
    ('gen-88c5644acaf32a07', 'assassins-creed'),
    ('gen-300bc83238e1f6f3', 'just-dance'),
    ('gen-bfbdca05467fe839', 'cinema'),
    ('gen-bfbdca05467fe839', 'entreprise'),
    ('gen-4076186e59eea139', 'trackmania'),
    ('gen-56c5d9b2750ee24c', 'final-fantasy'),
    ('gen-77a54b4cc9cf4f1e', 'final-fantasy'),
    ('gen-48ff14999e4aef77', 'final-fantasy'),
    ('gen-48ff14999e4aef77', 'nintendo'),
    ('gen-9570b0d25e80e929', 'final-fantasy'),
    ('gen-0ffdc75e8ad739d5', 'final-fantasy'),
    ('gen-e041719c754114dd', 'final-fantasy'),
    ('gen-be6742b958c958c6', 'jeu'),
    ('gen-5737a663835bab76', 'jeu'),
    ('gen-cc0891ac89728dcc', 'jeu'),
    ('gen-2bec81be8865a832', 'jeu'),
    ('gen-fecbe7229e169156', 'jeu'),
    ('gen-3217f70f58e35b86', 'world-of-warcraft'),
    ('gen-b6945d6ef5399caf', 'world-of-warcraft'),
    ('gen-7f89fe61c69bbdeb', 'world-of-warcraft'),
    ('gen-bca795e4f22b9e55', 'world-of-warcraft'),
    ('gen-aa770a649704f476', 'world-of-warcraft'),
    ('gen-05b40dffbc996583', 'league-of-legends'),
    ('gen-a3a5a2cef5051895', 'league-of-legends'),
    ('gen-88a5984825633f0e', 'league-of-legends'),
    ('gen-0a9e386f7ca7d67a', 'league-of-legends'),
    ('gen-aee0d746b872d669', 'league-of-legends'),
    ('gen-9ae5db131e296bf3', 'league-of-legends'),
    ('gen-c44bb03abef90c13', 'league-of-legends'),
    ('gen-1179ce4a00f82554', 'league-of-legends'),
    ('gen-897025555922e86c', 'league-of-legends'),
    ('gen-9829aaf09f6d42a1', 'mario'),
    ('gen-9829aaf09f6d42a1', 'nintendo'),
    ('gen-7c7675227f2fb6c8', 'mario'),
    ('gen-7c7675227f2fb6c8', 'nintendo'),
    ('gen-3a7ce5a36402ae11', 'mario'),
    ('gen-3a7ce5a36402ae11', 'nintendo'),
    ('gen-ed1b4ab1e86d3116', 'mario'),
    ('gen-ed1b4ab1e86d3116', 'nintendo'),
    ('gen-2eb94cad6d07fa98', 'mario'),
    ('gen-2eb94cad6d07fa98', 'nintendo'),
    ('gen-326a6b9733e77d84', 'mario'),
    ('gen-326a6b9733e77d84', 'nintendo'),
    ('gen-6fd0f0bacd66edc4', 'mario'),
    ('gen-6fd0f0bacd66edc4', 'nintendo'),
    ('gen-4d9514597eae5b9f', 'mario'),
    ('gen-4d9514597eae5b9f', 'nintendo'),
    ('gen-1ce6dc7a8227e23f', 'mario'),
    ('gen-1ce6dc7a8227e23f', 'nintendo'),
    ('gen-cb7bfd3fd13c8a62', 'mario'),
    ('gen-cb7bfd3fd13c8a62', 'nintendo'),
    ('gen-7363bb4a5ba4f152', 'nintendo'),
    ('gen-315c133ddb91494d', 'tetris'),
    ('gen-39df2050bffec9a4', 'nintendo'),
    ('gen-76153bb20ddd0707', 'nintendo'),
    ('gen-3d4e0d9881817bed', 'pokemon'),
    ('gen-455726eebe614de5', 'nintendo'),
    ('gen-b4797fe4b7075dd2', 'nintendo'),
    ('gen-e8894b68492f67bb', 'nintendo'),
    ('gen-becda6913162a0e6', 'nintendo'),
    ('gen-2e8ca6dc2196dccd', 'nintendo'),
    ('gen-652359fc2049e449', 'nintendo'),
    ('gen-e11169eac81ac8c8', 'jeu'),
    ('gen-de6f0aa4d171580b', 'jeu'),
    ('gen-60943d5601ef7689', 'jeu'),
    ('gen-6a62d2d08c3c6773', 'jeu'),
    ('gen-31788aa492fca987', 'jeu'),
    ('gen-1a4119ecb2d47478', 'jeu'),
    ('gen-18ec1ebba1914b92', 'jeu'),
    ('gen-30c47d59be973cf8', 'jeu'),
    ('gen-ef10b4890864dcb5', 'histoire'),
    ('gen-ef10b4890864dcb5', 'nintendo'),
    ('gen-31a9688096c65e91', 'nintendo'),
    ('gen-63aa0130f3055212', 'nintendo'),
    ('gen-62bcb2c9e8b6ddd7', 'entreprise'),
    ('gen-62bcb2c9e8b6ddd7', 'nintendo'),
    ('gen-37e6af008fd9ef63', 'nintendo'),
    ('gen-608ed10b65d9c371', 'nintendo'),
    ('gen-76a9d92f8865eab9', 'nintendo'),
    ('gen-ce86d0a83243378f', 'nintendo'),
    ('gen-e61a45639d89a605', 'nintendo'),
    ('gen-322145f45a92d762', 'nintendo'),
    ('gen-cef975c22eaf9992', 'nintendo'),
    ('gen-1a9c010af1772c49', 'nintendo'),
    ('gen-1ad6bc7578f7c723', 'pokemon'),
    ('gen-0ddcbaa5d019dde3', 'pokemon'),
    ('gen-b5beda59d985782a', 'pokemon'),
    ('gen-d85999325be5bed4', 'pokemon'),
    ('gen-a00525c4c82a1430', 'pokemon'),
    ('gen-3a4abf7681c95d53', 'pokemon'),
    ('gen-aeaef22c20949e0e', 'pokemon'),
    ('gen-d05d77224bc6df26', 'nintendo'),
    ('gen-d05d77224bc6df26', 'zelda'),
    ('gen-d43d4fe6f03d1f39', 'lord-of-the-rings'),
    ('gen-d43d4fe6f03d1f39', 'nintendo'),
    ('gen-d43d4fe6f03d1f39', 'zelda'),
    ('gen-98f98430ee3ff270', 'nintendo'),
    ('gen-98f98430ee3ff270', 'zelda'),
    ('gen-75f60e8f1d0de817', 'nintendo'),
    ('gen-75f60e8f1d0de817', 'zelda'),
    ('gen-00b849043c17d6e5', 'nintendo'),
    ('gen-00b849043c17d6e5', 'zelda'),
    ('gen-00b2f5a1146afd0e', 'nintendo'),
    ('gen-00b2f5a1146afd0e', 'zelda'),
    ('gen-bdc3cf5d62ee88b1', 'nintendo'),
    ('gen-bdc3cf5d62ee88b1', 'zelda'),
    ('gen-b45a65c14abad8af', 'nintendo'),
    ('gen-b45a65c14abad8af', 'zelda'),
    ('gen-aab5984b272578f3', 'mario'),
    ('gen-aab5984b272578f3', 'nintendo'),
    ('gen-19fdc572bd0b826c', 'mario'),
    ('gen-19fdc572bd0b826c', 'nintendo'),
    ('gen-e88c7c4b6e60a547', 'mario'),
    ('gen-e88c7c4b6e60a547', 'nintendo'),
    ('gen-c012e082c0b6472b', 'mario'),
    ('gen-c012e082c0b6472b', 'nintendo'),
    ('gen-a666f2949d64f3ff', 'mario'),
    ('gen-a666f2949d64f3ff', 'nintendo'),
    ('gen-6b226fb19cb2709a', 'mario'),
    ('gen-8f2f25401d46521e', 'mario'),
    ('gen-dd0f0757c8b5ed9e', 'nintendo'),
    ('gen-dd0f0757c8b5ed9e', 'sony'),
    ('gen-ec6af655e37d8350', 'sony'),
    ('gen-f42462b251d0a5ad', 'nintendo'),
    ('gen-df2d8fe9c05cc944', 'sony'),
    ('gen-0ef5803b52e838dd', 'sega'),
    ('gen-0ef5803b52e838dd', 'sony'),
    ('gen-345bd33a297401af', 'sega'),
    ('gen-345bd33a297401af', 'sony'),
    ('gen-bf7bf663ce4aeb5f', 'sony'),
    ('gen-9b20e8f8104bbb38', 'sega'),
    ('gen-9b20e8f8104bbb38', 'sony'),
    ('gen-ccb213b72ae0908a', 'sony'),
    ('gen-1ee59774fbe9822e', 'entreprise'),
    ('gen-1ee59774fbe9822e', 'jeu'),
    ('gen-e62686ab77c88b81', 'jeu'),
    ('gen-e62686ab77c88b81', 'rayman'),
    ('gen-20e60a1837305d73', 'jeu'),
    ('gen-21edc4bac347447d', 'jeu'),
    ('gen-18fb3a7e0c15a8a9', 'james-bond'),
    ('gen-18fb3a7e0c15a8a9', 'jeu'),
    ('gen-a8fd079b9311aadc', 'just-dance'),
    ('gen-48a70cf8d6329900', 'assassins-creed'),
    ('gen-612bebe712d4fb1a', 'entreprise'),
    ('gen-4e1c7232435792ed', 'cinema'),
    ('gen-4e1c7232435792ed', 'television'),
    ('gen-c9c92da3fc8313a7', 'lieu'),
    ('gen-f139f44187bee84e', 'lieu'),
    ('gen-b387f2f154bb1dea', 'lieu'),
    ('gen-f1ec4363c0d6ca22', 'lieu'),
    ('gen-341a50c2535ecec1', 'lieu'),
    ('gen-4701605c84e4fef4', 'lieu'),
    ('gen-889f932647f2be16', 'lieu'),
    ('gen-d89f04b7ce237a36', 'lieu'),
    ('gen-f02336819a637e93', 'lieu'),
    ('gen-e24cf4f40799f873', 'lieu'),
    ('gen-82dc778047fb7d00', 'lieu'),
    ('gen-b7123feb4af475c7', 'histoire'),
    ('gen-b7123feb4af475c7', 'lieu'),
    ('gen-bc1397373aa51099', 'lieu'),
    ('gen-b44cc46f10985df3', 'lieu'),
    ('gen-4cb00b5769725d0d', 'lieu'),
    ('gen-2e0f218d80833489', 'lieu'),
    ('gen-91e9e24b07b61eeb', 'lieu'),
    ('gen-b7a02adf0f2f9bd5', 'histoire'),
    ('gen-808bf55cb614f21d', 'lieu'),
    ('gen-b8444ec31454a101', 'lieu'),
    ('gen-6881f2f4310b906c', 'lieu'),
    ('gen-b06f500d4bff53d9', 'lieu'),
    ('gen-575d313ea3610505', 'lieu'),
    ('gen-c6a08ce01db7b9b7', 'lieu'),
    ('gen-8d5c59dd1fd6a3d9', 'lieu'),
    ('gen-793502c19730cc36', 'lieu'),
    ('gen-064fa209d2b7a696', 'lieu'),
    ('gen-9663db8e48c2c4d0', 'lieu'),
    ('gen-e762a3ee461bc72f', 'lieu'),
    ('gen-dd24aea89091e0ad', 'lieu'),
    ('gen-a6b6175c745ef6ba', 'lieu'),
    ('gen-55dbfc493d9457a2', 'lieu'),
    ('gen-fae6b107242a0ec5', 'lieu'),
    ('gen-1183f480ed99fbd4', 'histoire'),
    ('gen-677dedca4779a774', 'lieu'),
    ('gen-45d76f7970a9837f', 'histoire'),
    ('gen-45d76f7970a9837f', 'lieu'),
    ('gen-f2d4fec5940e975e', 'histoire'),
    ('gen-f2d4fec5940e975e', 'lieu'),
    ('gen-236e9d62a2059bd1', 'histoire'),
    ('gen-236e9d62a2059bd1', 'lieu'),
    ('gen-690a25fb931223c1', 'lieu'),
    ('gen-c42f35481797dd59', 'lieu'),
    ('gen-2754ef8dd5c576b7', 'histoire'),
    ('gen-2754ef8dd5c576b7', 'lieu'),
    ('gen-66674683009e6274', 'histoire'),
    ('gen-66674683009e6274', 'lieu'),
    ('gen-f0f1669cf8214af4', 'lieu'),
    ('gen-c5c458b76de87c4b', 'lieu'),
    ('gen-de926938e22b7f78', 'lieu'),
    ('gen-6762ba910ecb0bca', 'lieu'),
    ('gen-c9f3a431ecb66653', 'lieu'),
    ('gen-653ddee3377dcf7f', 'histoire'),
    ('gen-653ddee3377dcf7f', 'lieu'),
    ('gen-bf24fbd9091a6a51', 'lieu'),
    ('gen-bf24fbd9091a6a51', 'science'),
    ('gen-6da9ce0fe2703dab', 'lieu'),
    ('gen-9517bbb9e647185f', 'histoire'),
    ('gen-08b756d2494299db', 'histoire'),
    ('gen-e186730fff16c069', 'histoire'),
    ('gen-e186730fff16c069', 'science'),
    ('gen-daa65bae5140da3e', 'lieu'),
    ('gen-8403d0410c5eef31', 'lieu'),
    ('gen-54e9217497390279', 'lieu'),
    ('gen-c4b407952bbd462f', 'lieu'),
    ('gen-58048a24c2da25f9', 'lieu'),
    ('gen-4de4ee376a01d8c6', 'lieu'),
    ('gen-179c23209d13e8b6', 'histoire'),
    ('gen-179c23209d13e8b6', 'lieu'),
    ('gen-0b36c49d93baa0b8', 'lieu'),
    ('gen-712d9054f2340017', 'histoire'),
    ('gen-712d9054f2340017', 'lieu'),
    ('gen-0df8353e63643699', 'lieu'),
    ('gen-b0d13d6fa4835f06', 'lieu'),
    ('gen-3d444b8d500bc806', 'lieu'),
    ('gen-34e9316b34002403', 'lieu'),
    ('gen-60d79649ab4a7396', 'lieu'),
    ('gen-b843de9717efa9c2', 'lieu'),
    ('gen-1a38e3ddddf3cc21', 'lieu'),
    ('gen-ed5cfc31a86fcc81', 'lieu'),
    ('gen-7f1faad58768eda0', 'histoire'),
    ('gen-7f1faad58768eda0', 'lieu'),
    ('gen-1a009521a2b2c781', 'lieu'),
    ('gen-7dbf5364595a9d3d', 'histoire'),
    ('gen-51563fbafb690038', 'histoire'),
    ('gen-3fe33864dde59efc', 'lieu'),
    ('gen-d113c249ae639c4e', 'histoire'),
    ('gen-d113c249ae639c4e', 'lieu'),
    ('gen-43de413be0d95b1d', 'lieu'),
    ('gen-c7eaa488f9888e91', 'lieu'),
    ('gen-9e4bd4e723d67c52', 'lieu'),
    ('gen-419e7a4807c02597', 'lieu'),
    ('gen-675f7279a0d1d498', 'lieu'),
    ('gen-3310df182a9e3c74', 'lieu'),
    ('gen-42af8533bc6fd7fd', 'lieu'),
    ('gen-c9ee1ee7bab7cdaa', 'lieu'),
    ('gen-349bd2deca627f49', 'histoire'),
    ('gen-349bd2deca627f49', 'lieu'),
    ('gen-fc0a0f96efdbef44', 'lieu'),
    ('gen-6467df1897de9f82', 'science'),
    ('gen-36676fbce7fdf403', 'lieu'),
    ('gen-48e02e259b99d36a', 'lieu'),
    ('gen-f88400900bc1e052', 'lieu'),
    ('gen-b9f5ce0bf11ffed2', 'lieu'),
    ('gen-e986df2d83b417e0', 'lieu'),
    ('gen-b92cf13cdc3e28a2', 'lieu'),
    ('gen-e071d520265b6067', 'entreprise'),
    ('gen-c9a1ab86adc512db', 'histoire'),
    ('gen-c9a1ab86adc512db', 'lieu'),
    ('gen-bf86f62cd8f857f1', 'lieu'),
    ('gen-4a655a6b9c8ea94b', 'histoire'),
    ('gen-4a655a6b9c8ea94b', 'lieu'),
    ('gen-59c21ee6cde8897b', 'histoire'),
    ('gen-59c21ee6cde8897b', 'lieu'),
    ('gen-ff16847f8da11931', 'lieu'),
    ('gen-aa232ee52b4ab4d9', 'histoire'),
    ('gen-88b6549d69cca133', 'histoire'),
    ('gen-cac6bc7b600b6eda', 'histoire'),
    ('gen-7d78f1c53f89e2d3', 'lieu'),
    ('gen-fa536819d671f46a', 'lieu'),
    ('gen-92040e92f14cf81f', 'histoire'),
    ('gen-940217e782828256', 'histoire'),
    ('gen-940217e782828256', 'lieu'),
    ('gen-17eae75356d7a093', 'histoire'),
    ('gen-17eae75356d7a093', 'lieu'),
    ('gen-5db4fce585cea7db', 'histoire'),
    ('gen-f18b0028e19c1b1f', 'histoire'),
    ('gen-f18b0028e19c1b1f', 'lieu'),
    ('gen-3250e0fd8781c000', 'histoire'),
    ('gen-3250e0fd8781c000', 'lieu'),
    ('gen-a3a47a4f50e7b03d', 'lieu'),
    ('gen-d0ec3bfb992fb8dd', 'lieu'),
    ('gen-e283b797615d08db', 'histoire'),
    ('gen-e283b797615d08db', 'lieu'),
    ('gen-80f989c4143fe7a6', 'lieu'),
    ('gen-2ce34ee4114a44d5', 'histoire'),
    ('gen-2ce34ee4114a44d5', 'lieu'),
    ('gen-033643e6dec0dd1e', 'histoire'),
    ('gen-033643e6dec0dd1e', 'lieu'),
    ('gen-3e8f0d461810ec94', 'histoire'),
    ('gen-3e8f0d461810ec94', 'science'),
    ('gen-bfb702bb4653e32b', 'histoire'),
    ('gen-bfb702bb4653e32b', 'lieu'),
    ('gen-a1399b313efdadc6', 'lieu'),
    ('gen-b13f42c3310687b2', 'lieu'),
    ('gen-9b5f6b91756933a4', 'histoire'),
    ('gen-d7fe4d1dc68f40d7', 'histoire'),
    ('gen-661fbc1970d3236f', 'lieu'),
    ('gen-ddfb6cc379c7f0f4', 'rome'),
    ('gen-e8386e9bb0b02595', 'rome'),
    ('gen-0353ac8dcb408308', 'rome'),
    ('gen-4824428d4b3f4e05', 'rome'),
    ('gen-b045d11e047534dd', 'rome'),
    ('gen-529e183eb07d071e', 'rome'),
    ('gen-9a480b4919c99b66', 'lieu'),
    ('gen-ba7e075f88f40972', 'lieu'),
    ('gen-0469b440fa1df150', 'histoire'),
    ('gen-980136d1881b0c33', 'science'),
    ('gen-8262e3015beef140', 'lieu'),
    ('gen-505b6b6c6f8e7c8d', 'lieu'),
    ('gen-7d59e902ad249f0b', 'lieu'),
    ('gen-7ccd15b333da25a6', 'lieu'),
    ('gen-287f233778cabe71', 'histoire'),
    ('gen-f76dd1bfa71a0bc7', 'histoire'),
    ('gen-696acd5e7c6780fc', 'histoire'),
    ('gen-decf88ef53bc59cb', 'histoire'),
    ('gen-84e90794fd05592e', 'histoire'),
    ('gen-f8694eca340743bc', 'histoire'),
    ('gen-6da914098d087f5b', 'histoire'),
    ('gen-37c39ca04bb71538', 'histoire'),
    ('gen-72e997ceec570eb7', 'lieu'),
    ('gen-010f5b9a3393da3d', 'histoire'),
    ('gen-010f5b9a3393da3d', 'lieu'),
    ('gen-10aae69abe6800eb', 'lieu'),
    ('gen-10aae69abe6800eb', 'science'),
    ('gen-ffb682220ba9f0a4', 'lieu'),
    ('gen-ffb682220ba9f0a4', 'science'),
    ('gen-969d6caaa5c043e5', 'histoire'),
    ('gen-969d6caaa5c043e5', 'lieu'),
    ('gen-b66110ccd882282f', 'lieu'),
    ('gen-6d7ddd8cfe9bd1f1', 'lieu'),
    ('gen-2c92d6bcfda11f3f', 'lieu'),
    ('gen-2c92d6bcfda11f3f', 'science'),
    ('gen-0c627bd6055c9024', 'lieu'),
    ('gen-5d50cc30d65a784c', 'lieu'),
    ('gen-d4dcc48fb5a6eec3', 'lieu'),
    ('gen-d4dcc48fb5a6eec3', 'science'),
    ('gen-979cbefdaa4fd01e', 'lieu'),
    ('gen-27ea980d2450ca1b', 'lieu'),
    ('gen-031880a79fd01789', 'histoire'),
    ('gen-031880a79fd01789', 'lieu'),
    ('gen-1ff509a0cdbff5c8', 'histoire'),
    ('gen-1ff509a0cdbff5c8', 'lieu'),
    ('gen-5026f9544d65b751', 'histoire'),
    ('gen-5026f9544d65b751', 'lieu'),
    ('gen-2f57591338bb9883', 'histoire'),
    ('gen-2f57591338bb9883', 'lieu'),
    ('gen-41efbd46c72971f6', 'histoire'),
    ('gen-41efbd46c72971f6', 'lieu'),
    ('gen-ccee35e7742bde94', 'histoire'),
    ('gen-ccee35e7742bde94', 'lieu'),
    ('gen-b40a240fd9645218', 'lieu'),
    ('gen-c1c2f0b8b64d321c', 'lieu'),
    ('gen-e2211de4ed973ed5', 'lieu'),
    ('gen-a348e74283d5c7e7', 'lieu'),
    ('gen-83669a1be9f361b7', 'lieu'),
    ('gen-b02709823b560b77', 'lieu'),
    ('gen-263ad8be7fdbc168', 'science'),
    ('gen-8f694d0804b19c56', 'science'),
    ('gen-eae39665e56e81a7', 'lieu'),
    ('gen-0a38bfc4a369371d', 'histoire'),
    ('gen-39e6d1b916c8e412', 'lieu'),
    ('gen-bb09aebce5ed10bd', 'biologie'),
    ('gen-f6ddd10589b7ebfa', 'histoire'),
    ('gen-f6ddd10589b7ebfa', 'lieu'),
    ('gen-8128f42cbc2cc7c3', 'histoire'),
    ('gen-8128f42cbc2cc7c3', 'lieu'),
    ('gen-09aaa047a29e1ebf', 'biologie'),
    ('gen-bd3f22d93f8d3720', 'histoire'),
    ('gen-bd3f22d93f8d3720', 'rome'),
    ('gen-82564370e5e6fe2d', 'histoire'),
    ('gen-ae84634d5e281825', 'science'),
    ('gen-767fe9943ae90868', 'science'),
    ('gen-f19583a03e3cc45a', 'science'),
    ('gen-d0b454a8e67a298e', 'lieu'),
    ('gen-f92c049b1cb50549', 'lieu'),
    ('gen-7fb79e3207a9283c', 'histoire'),
    ('gen-7fb79e3207a9283c', 'lieu'),
    ('gen-bda64a0e0afe818a', 'lieu'),
    ('gen-5fa8bfef28a33912', 'lieu'),
    ('gen-9acb5758374a27e2', 'lieu'),
    ('gen-e28cebfabe5b6f46', 'lieu'),
    ('gen-8f2de2131ce578ef', 'histoire'),
    ('gen-8f2de2131ce578ef', 'lieu'),
    ('gen-1bcb6b0ea97c6ac1', 'lieu'),
    ('gen-4b00bfdb2a52cfc2', 'lieu'),
    ('gen-1b7d0c100af7a893', 'lieu'),
    ('gen-e2cb3eafa100f5e0', 'lieu'),
    ('gen-1ae3c2e7cad997e9', 'lieu'),
    ('gen-52e9a14f1787c0e1', 'lieu'),
    ('gen-069ce8be9ae87421', 'lieu'),
    ('gen-e3b3fb8d5947f73d', 'histoire'),
    ('gen-e3b3fb8d5947f73d', 'lieu'),
    ('gen-5f1f689c230a8703', 'histoire'),
    ('gen-aa0570cf4d1ede73', 'histoire'),
    ('gen-aa0570cf4d1ede73', 'rome'),
    ('gen-bd647bc28529b5a9', 'science'),
    ('gen-13f802767a634c15', 'histoire'),
    ('gen-13f802767a634c15', 'rome'),
    ('gen-2c3f2fda7029e146', 'lieu'),
    ('gen-03c95e8adc4fde3a', 'histoire'),
    ('gen-c9591466b39f4e5b', 'histoire'),
    ('gen-bf8c7d771c8bf21c', 'histoire'),
    ('gen-bf8c7d771c8bf21c', 'lieu'),
    ('gen-b7decbd57fc5d22c', 'lieu'),
    ('gen-774e2e1332cb16fd', 'histoire'),
    ('gen-744df655ad5c6ca9', 'science'),
    ('gen-6c04942f0f0abdcf', 'histoire'),
    ('gen-6c04942f0f0abdcf', 'lieu'),
    ('gen-a85eb4467de9af14', 'histoire'),
    ('gen-a85eb4467de9af14', 'lieu'),
    ('gen-ee1906d2927164fb', 'lieu'),
    ('gen-0b48f5ffa3a9c595', 'lieu'),
    ('gen-5e8eb7380f2a096f', 'histoire'),
    ('gen-5e8eb7380f2a096f', 'lieu'),
    ('gen-03e3eb71ae85b314', 'lieu'),
    ('gen-def870b06a9a51e0', 'lieu'),
    ('gen-8ec123299b0099b7', 'histoire'),
    ('gen-8ec123299b0099b7', 'lieu'),
    ('gen-e24649e8d15cd679', 'lieu'),
    ('gen-7c2fceda3fbb1f2e', 'lieu'),
    ('gen-ae58b61db0df8b71', 'histoire'),
    ('gen-240a71d101d5e481', 'lieu'),
    ('gen-b60322ad74fadc57', 'lieu'),
    ('gen-bd9b36b2e3d6e19b', 'lieu'),
    ('gen-1fd59c5dc2081c42', 'histoire'),
    ('gen-1fd59c5dc2081c42', 'rome'),
    ('gen-3969056f37df734d', 'lieu'),
    ('gen-50d5d7daa6e52709', 'histoire'),
    ('gen-07cc857976d90ea3', 'lieu'),
    ('gen-17938b96b3f8170d', 'histoire'),
    ('gen-1d5349db8f9b6cb5', 'lieu'),
    ('gen-0241e033eaf3d3eb', 'lieu'),
    ('gen-be20ca38cb523ec2', 'histoire'),
    ('gen-be20ca38cb523ec2', 'lieu'),
    ('gen-8dd1585d1701f25b', 'histoire'),
    ('gen-8dd1585d1701f25b', 'lieu'),
    ('gen-199a2613dba4a79d', 'lieu'),
    ('gen-14df381a823f2aa9', 'lieu'),
    ('gen-0f47c920dbc58412', 'lieu'),
    ('gen-259fe80a6541caf0', 'lieu'),
    ('gen-cf6e4bd6050d480a', 'lieu'),
    ('gen-fba80a15ddf7fc25', 'lieu'),
    ('gen-3b39e51408c6ace6', 'biologie'),
    ('gen-15731fda2d357d69', 'biologie'),
    ('gen-99731c3799f73940', 'science'),
    ('gen-889bb2d94f7e8f2f', 'biologie'),
    ('gen-a6064bfa55f0c429', 'biologie'),
    ('gen-46604fdddede30de', 'biologie'),
    ('gen-0dde92d08fbf2419', 'biologie'),
    ('gen-1e98c6fdd7176268', 'biologie'),
    ('gen-d17d2598be2c596a', 'biologie'),
    ('gen-c54b807ce5d6b868', 'biologie'),
    ('gen-dbe2adc2a7d55412', 'anatomie'),
    ('gen-dbe2adc2a7d55412', 'biologie'),
    ('gen-6751cb66efb5c6f3', 'anatomie'),
    ('gen-6751cb66efb5c6f3', 'biologie'),
    ('gen-fc626b32e9e5938e', 'biologie'),
    ('gen-e87f25eaca6755cf', 'biologie'),
    ('gen-e87f25eaca6755cf', 'science'),
    ('gen-28c19e8909570b75', 'anatomie'),
    ('gen-28c19e8909570b75', 'biologie'),
    ('gen-bb3c95cad74e56e2', 'anatomie'),
    ('gen-bb3c95cad74e56e2', 'biologie'),
    ('gen-54fc1830f039a143', 'biologie'),
    ('gen-54fc1830f039a143', 'chimie'),
    ('gen-6d481aad80072075', 'biologie'),
    ('gen-ffb4d0208a61a5a1', 'biologie'),
    ('gen-7b4e4ffb342d0e25', 'biologie'),
    ('gen-7b4e4ffb342d0e25', 'histoire'),
    ('gen-b34f206a60ab2add', 'anatomie'),
    ('gen-b34f206a60ab2add', 'biologie'),
    ('gen-b34f206a60ab2add', 'science'),
    ('gen-c1e194b83dbfc783', 'science'),
    ('gen-116233f618615639', 'science'),
    ('gen-df04b2ab23973420', 'science'),
    ('gen-c2dc96c7bcac7934', 'histoire'),
    ('gen-c2dc96c7bcac7934', 'science'),
    ('gen-09b21ace3d619bc6', 'chimie'),
    ('gen-09b21ace3d619bc6', 'science'),
    ('gen-a733b4aee06357b1', 'anatomie'),
    ('gen-a733b4aee06357b1', 'science'),
    ('gen-86897bcdb74fac10', 'anatomie'),
    ('gen-86897bcdb74fac10', 'science'),
    ('gen-e36443ed186c41f7', 'anatomie'),
    ('gen-e36443ed186c41f7', 'science'),
    ('gen-cafce6f8a24517d0', 'anatomie'),
    ('gen-cafce6f8a24517d0', 'science'),
    ('gen-2f965e5ea321440c', 'anatomie'),
    ('gen-2f965e5ea321440c', 'science'),
    ('gen-0b9ee433c67c2156', 'anatomie'),
    ('gen-0b9ee433c67c2156', 'science'),
    ('gen-4bde83b36d7b0b27', 'science'),
    ('gen-7ea4db7c9c966a5e', 'science'),
    ('gen-9eabb0ddc9069027', 'histoire'),
    ('gen-9eabb0ddc9069027', 'science'),
    ('gen-b490c02a4225777e', 'histoire'),
    ('gen-b490c02a4225777e', 'science'),
    ('gen-abe3dfd2427ca5c2', 'histoire'),
    ('gen-abe3dfd2427ca5c2', 'science'),
    ('gen-daa6da5f3f83b8c5', 'science'),
    ('gen-3de1d1571993afe8', 'science'),
    ('gen-d9fcd957b3bc1436', 'science'),
    ('gen-e8018c799a52db4d', 'science'),
    ('gen-2a93a24640d5e2e5', 'science'),
    ('gen-12962f7f13575ffe', 'science'),
    ('gen-d3acafaabea05357', 'science'),
    ('gen-f3d1190d0164b05f', 'science'),
    ('gen-9f31dee119f9b381', 'science'),
    ('gen-13475bba01d520dd', 'science'),
    ('gen-38564b7a14683a34', 'science'),
    ('gen-248ad5d989ac099d', 'science'),
    ('gen-faee2433aa1dd805', 'science'),
    ('gen-a7b10b3a0fb65652', 'science'),
    ('gen-e4bfa417d14c3a25', 'science'),
    ('gen-7ef7082198281353', 'science'),
    ('gen-4668a272f04b0465', 'biologie'),
    ('gen-78ee6be59c2bfea2', 'biologie'),
    ('gen-9624eec88febb110', 'biologie'),
    ('gen-896521ee0dce72d8', 'biologie'),
    ('gen-9629c5bac375620f', 'biologie'),
    ('gen-bea471117f406271', 'science'),
    ('gen-7d829dbddd89af9f', 'science'),
    ('gen-ded667c41bcb5d99', 'science'),
    ('gen-e1e2b9e0a24ebb51', 'biologie'),
    ('gen-e1e2b9e0a24ebb51', 'science'),
    ('gen-1d5c4e3c0231c29d', 'science'),
    ('gen-62d20361dc074a1d', 'biologie'),
    ('gen-62d20361dc074a1d', 'science'),
    ('gen-83dc1188a1f491ce', 'biologie'),
    ('gen-83dc1188a1f491ce', 'science'),
    ('gen-54c3eeb325c59649', 'histoire'),
    ('gen-54c3eeb325c59649', 'science'),
    ('gen-fdd4d2586feab196', 'biologie'),
    ('gen-fdd4d2586feab196', 'science'),
    ('gen-8855b9d71afe5aaa', 'biologie'),
    ('gen-8855b9d71afe5aaa', 'science'),
    ('gen-d579777f863b1999', 'biologie'),
    ('gen-d579777f863b1999', 'science'),
    ('gen-b3b63bd564dff2dc', 'biologie'),
    ('gen-32be988097198bfc', 'anatomie'),
    ('gen-32be988097198bfc', 'biologie'),
    ('gen-2e497cd4da99e608', 'biologie'),
    ('gen-de78681ce2700373', 'biologie'),
    ('gen-369f2a11d8b3f77e', 'biologie'),
    ('gen-d35c62d8ef6fa105', 'biologie'),
    ('gen-d35c62d8ef6fa105', 'science'),
    ('gen-5423c21ce4e5ddf0', 'histoire'),
    ('gen-5423c21ce4e5ddf0', 'science'),
    ('gen-a9072dee9ea1bf5f', 'anatomie'),
    ('gen-a9072dee9ea1bf5f', 'science'),
    ('gen-e84766e33bb4e738', 'histoire'),
    ('gen-e84766e33bb4e738', 'science'),
    ('gen-2a9a321e78d1bcbc', 'histoire'),
    ('gen-2a9a321e78d1bcbc', 'science'),
    ('gen-4466d244f9ace1f2', 'histoire'),
    ('gen-4466d244f9ace1f2', 'science'),
    ('gen-16fe076eefe4680a', 'biologie'),
    ('gen-16fe076eefe4680a', 'science'),
    ('gen-9e8ea15a432a7638', 'biologie'),
    ('gen-9e8ea15a432a7638', 'science'),
    ('gen-c76d0e3aa8c5c681', 'biologie'),
    ('gen-c76d0e3aa8c5c681', 'science'),
    ('gen-3d9390e9d2c6c570', 'biologie'),
    ('gen-3d9390e9d2c6c570', 'science'),
    ('gen-ac9efd103a266f70', 'biologie'),
    ('gen-ac9efd103a266f70', 'science'),
    ('gen-24edc532a73e4ac9', 'biologie'),
    ('gen-24edc532a73e4ac9', 'science'),
    ('gen-d5806a7c9f2bd280', 'biologie'),
    ('gen-c7b991dc95924ae3', 'science'),
    ('gen-423a45195063d3d5', 'biologie'),
    ('gen-423a45195063d3d5', 'science'),
    ('gen-5aac08ca5315c59d', 'biologie'),
    ('gen-5aac08ca5315c59d', 'chimie'),
    ('gen-7d31d2e741e6805f', 'anatomie'),
    ('gen-7d31d2e741e6805f', 'biologie'),
    ('gen-74eeb3573e3e1258', 'biologie'),
    ('gen-74eeb3573e3e1258', 'science'),
    ('gen-daf1e6e12779ed43', 'biologie'),
    ('gen-daf1e6e12779ed43', 'science'),
    ('gen-0fc112705d3efad4', 'biologie'),
    ('gen-0fc112705d3efad4', 'science'),
    ('gen-fc4526362b468c31', 'biologie'),
    ('gen-fc4526362b468c31', 'science'),
    ('gen-883babe62d86409b', 'biologie'),
    ('gen-883babe62d86409b', 'science'),
    ('gen-f91a2dd2df0a0a02', 'anatomie'),
    ('gen-f91a2dd2df0a0a02', 'biologie'),
    ('gen-f91a2dd2df0a0a02', 'science'),
    ('gen-0cbebe5ae8385770', 'biologie'),
    ('gen-0cbebe5ae8385770', 'science'),
    ('gen-cbb6e2ebeb4375db', 'science'),
    ('gen-c9892ab676f1ee1b', 'science'),
    ('gen-f5b844c540f99027', 'science'),
    ('gen-e74c7ea3c88dea8a', 'science'),
    ('gen-a4010abdeff5527c', 'biologie'),
    ('gen-a4010abdeff5527c', 'science'),
    ('gen-120c545369ca3bdb', 'science'),
    ('gen-348046866f283441', 'science'),
    ('gen-86a6378333bd3dd3', 'chimie'),
    ('gen-86a6378333bd3dd3', 'science'),
    ('gen-e0d97dcb1eb900e2', 'chimie'),
    ('gen-e0d97dcb1eb900e2', 'science'),
    ('gen-a9beea9b03fd49ac', 'science'),
    ('gen-a02b95afb3cff805', 'chimie'),
    ('gen-a02b95afb3cff805', 'science'),
    ('gen-5ab0665c3502b460', 'chimie'),
    ('gen-5ab0665c3502b460', 'science'),
    ('gen-b9ccfa5ecc67a5df', 'chimie'),
    ('gen-b9ccfa5ecc67a5df', 'science'),
    ('gen-49fa7c24d3a5895d', 'anatomie'),
    ('gen-49fa7c24d3a5895d', 'biologie'),
    ('gen-043ca445a60ce41c', 'science'),
    ('gen-38c805b15ab0a776', 'anatomie'),
    ('gen-38c805b15ab0a776', 'biologie'),
    ('gen-03ab9e951c4ced9e', 'biologie'),
    ('gen-3e12fcc09b45ce88', 'astronomie'),
    ('gen-d536934cb38f2e2d', 'science'),
    ('gen-43b9e2d81fb48ddd', 'science'),
    ('gen-d81e60ca0b8ea01b', 'science'),
    ('gen-9bab332208d6db85', 'science'),
    ('gen-e17d9975f286b2b7', 'science'),
    ('gen-26c4e86e30564487', 'science'),
    ('gen-b0b1250380beeccc', 'science'),
    ('gen-a1fb53607a9ed813', 'science'),
    ('gen-875fa609e82939be', 'science'),
    ('gen-88c9e6008e18a30f', 'science'),
    ('gen-5123444e61a59519', 'lieu'),
    ('gen-5123444e61a59519', 'science'),
    ('gen-62b7c3999f7a3a42', 'science'),
    ('gen-88769970423477f4', 'science'),
    ('gen-27d23deb9f929f13', 'astronomie'),
    ('gen-ec43fdd8f15b8613', 'astronomie'),
    ('gen-7e4129801164157a', 'astronomie'),
    ('gen-ca359008f7fa4767', 'astronomie'),
    ('gen-ca359008f7fa4767', 'science'),
    ('gen-09d722ffaab514c1', 'astronomie'),
    ('gen-2b6edfa7923d6b16', 'astronomie'),
    ('gen-5975ceb58b0d3fcb', 'astronomie'),
    ('gen-c50d0c670a467fba', 'astronomie'),
    ('gen-e1db3ee30d26e923', 'astronomie'),
    ('gen-434ecf3d1d26f2a0', 'astronomie'),
    ('gen-54971487a7bd8e2d', 'science'),
    ('gen-021ded5d317d81c1', 'science'),
    ('gen-02fa804d578c04a7', 'science'),
    ('gen-dd6c309921b0e45b', 'science'),
    ('gen-ab8208c2bc20cea8', 'science'),
    ('gen-8a63ff8952ae5e29', 'science'),
    ('gen-e767997be91654c3', 'astronomie'),
    ('gen-e767997be91654c3', 'science'),
    ('gen-b1f3c79c1f6ada86', 'astronomie'),
    ('gen-b1f3c79c1f6ada86', 'science'),
    ('gen-dc67ce52d3adae85', 'astronomie'),
    ('gen-dc67ce52d3adae85', 'science'),
    ('gen-5cc317cb00bd985d', 'astronomie'),
    ('gen-5cc317cb00bd985d', 'science'),
    ('gen-6ec5858edbb760c5', 'astronomie'),
    ('gen-6ec5858edbb760c5', 'science'),
    ('gen-b232593488121508', 'astronomie'),
    ('gen-b232593488121508', 'science'),
    ('gen-c126016d7b0de4eb', 'science'),
    ('gen-bb7ad90bbdb7ae8d', 'science'),
    ('gen-90178fdac55f653e', 'anatomie'),
    ('gen-90178fdac55f653e', 'science'),
    ('gen-a5d68ae705df9f60', 'astronomie'),
    ('gen-a5d68ae705df9f60', 'science'),
    ('gen-d03d3a8760eb5319', 'science'),
    ('gen-056366c46255127d', 'science'),
    ('gen-7f6c28142715b95c', 'science'),
    ('gen-22985d76bb296baa', 'science'),
    ('gen-9f88bd784e0d5867', 'science'),
    ('gen-03aa6be00703e3f7', 'science'),
    ('gen-4f0381d9b456de42', 'biologie'),
    ('gen-4f0381d9b456de42', 'science'),
    ('gen-ab3b6f259c0f9395', 'science'),
    ('gen-ea049ad03624944c', 'biologie'),
    ('gen-ea049ad03624944c', 'science'),
    ('gen-e104084fee00dd5f', 'science'),
    ('gen-f7b26a257353d150', 'science'),
    ('gen-4650f591c049dfcf', 'science'),
    ('gen-050d316be60bb271', 'science'),
    ('gen-1a3d5e808bdaa6b2', 'science'),
    ('gen-f0cecbb84ba43c23', 'science'),
    ('gen-e6013a62850df34b', 'science'),
    ('gen-6d5d9bbd4defed29', 'anatomie'),
    ('gen-6d5d9bbd4defed29', 'biologie'),
    ('gen-46999b127bafc85d', 'anatomie'),
    ('gen-46999b127bafc85d', 'biologie'),
    ('gen-5bb661e6e310db40', 'anatomie'),
    ('gen-5bb661e6e310db40', 'biologie'),
    ('gen-06cfd9d586f4854a', 'anatomie'),
    ('gen-06cfd9d586f4854a', 'science'),
    ('gen-21c1ec0498eefec5', 'biologie'),
    ('gen-bac6a4d409b83cdf', 'biologie'),
    ('gen-d581164fab307ee0', 'biologie'),
    ('gen-789e407e67fe0a43', 'biologie'),
    ('gen-965c094365786e32', 'anatomie'),
    ('gen-888480091ec01b6c', 'anatomie'),
    ('gen-986c08712d02ae92', 'anatomie'),
    ('gen-03e82dec4b572bc2', 'anatomie'),
    ('gen-03e82dec4b572bc2', 'science'),
    ('gen-1a1b9caa7291cd0b', 'anatomie'),
    ('gen-1a1b9caa7291cd0b', 'science'),
    ('gen-e9c90adf8c58ba13', 'histoire'),
    ('gen-e9c90adf8c58ba13', 'science'),
    ('gen-86f03ebab0c5a813', 'anatomie'),
    ('gen-86f03ebab0c5a813', 'science'),
    ('gen-e0701eaded66811f', 'anatomie'),
    ('gen-e0701eaded66811f', 'biologie'),
    ('gen-abbfbc26590ad4fa', 'anatomie'),
    ('gen-abbfbc26590ad4fa', 'biologie'),
    ('gen-3ccf78d79f60660f', 'anatomie'),
    ('gen-3ccf78d79f60660f', 'biologie'),
    ('gen-76382e4d009e6b0b', 'anatomie'),
    ('gen-76382e4d009e6b0b', 'biologie'),
    ('gen-24b2fb9465da8fb4', 'anatomie'),
    ('gen-24b2fb9465da8fb4', 'biologie'),
    ('gen-fe6e60d5d9c42606', 'anatomie'),
    ('gen-fe6e60d5d9c42606', 'biologie'),
    ('gen-3463f36d433f00e3', 'biologie'),
    ('gen-014b1eb153a7dc10', 'biologie'),
    ('gen-87a3217b215a727d', 'biologie'),
    ('gen-cb843ecb37bc1a11', 'biologie'),
    ('gen-b5a229a7e5329c3f', 'histoire'),
    ('gen-59133ff007e0e703', 'biologie'),
    ('gen-7965a9e8690af29a', 'biologie'),
    ('gen-f652cafd0266258f', 'biologie'),
    ('gen-6933344564287f39', 'biologie'),
    ('gen-dacb5113c9aef2f9', 'biologie'),
    ('gen-01dc6db397f814d5', 'biologie'),
    ('gen-f9da30f5b6bc2844', 'biologie'),
    ('gen-2d02fcef3feb97e7', 'biologie'),
    ('gen-384e94c9ddc6413d', 'biologie'),
    ('gen-d1574a05f6ca4b87', 'biologie'),
    ('gen-be548aafda62244e', 'biologie'),
    ('gen-794386c89e8f9ec7', 'biologie'),
    ('gen-ac2aabb12dd5ac39', 'histoire'),
    ('gen-49de248be75ab9a4', 'anatomie'),
    ('gen-49de248be75ab9a4', 'biologie'),
    ('gen-4a558a18a6c9e47b', 'anatomie'),
    ('gen-4a558a18a6c9e47b', 'biologie'),
    ('gen-f50a544fac5813cf', 'biologie'),
    ('gen-f50a544fac5813cf', 'histoire'),
    ('gen-3256a18e586e7f38', 'anatomie'),
    ('gen-3256a18e586e7f38', 'biologie'),
    ('gen-51c983808655bb5e', 'biologie'),
    ('gen-51c983808655bb5e', 'histoire'),
    ('gen-12068f6e2a726471', 'biologie'),
    ('gen-6a3261dfe97cc544', 'biologie'),
    ('gen-ce7c0e32eeaf3de3', 'biologie'),
    ('gen-ce7c0e32eeaf3de3', 'histoire'),
    ('gen-6fba8b942fc5c4a0', 'biologie'),
    ('gen-ef77a725e7849e99', 'biologie'),
    ('gen-ef77a725e7849e99', 'lieu'),
    ('gen-1854efe82988a351', 'biologie'),
    ('gen-b6c3edda42eed1f4', 'biologie'),
    ('gen-0acd248bb5086c1e', 'biologie'),
    ('gen-61e680bf0be3f622', 'science'),
    ('gen-4bfba7767c172cf7', 'science'),
    ('gen-a42457da40459591', 'histoire'),
    ('gen-a5c52aae529acc3b', 'histoire'),
    ('gen-f9b7075687c1630b', 'biologie'),
    ('gen-254ebf8c4973279d', 'biologie'),
    ('gen-4f63a25fb691de4b', 'biologie'),
    ('gen-4f63a25fb691de4b', 'lieu'),
    ('gen-3278479153c247bf', 'biologie'),
    ('gen-1e26f0a42b6d024e', 'biologie'),
    ('gen-1e26f0a42b6d024e', 'lieu'),
    ('gen-e7260a0b5763487a', 'biologie'),
    ('gen-24d76f7cac4cc8f3', 'biologie'),
    ('gen-24d76f7cac4cc8f3', 'unesco'),
    ('gen-a5a79cfbdfd4b9a5', 'biologie'),
    ('gen-a5a79cfbdfd4b9a5', 'lieu'),
    ('gen-1705b2b3d53dc5b9', 'anatomie'),
    ('gen-1705b2b3d53dc5b9', 'science'),
    ('gen-b4eb3ff189653549', 'anatomie'),
    ('gen-b4eb3ff189653549', 'science'),
    ('gen-24db62c0309572d7', 'histoire'),
    ('gen-24db62c0309572d7', 'science'),
    ('gen-9f6929bc1a1e090c', 'chimie'),
    ('gen-9f6929bc1a1e090c', 'science'),
    ('gen-8d797c1f12eaa613', 'histoire'),
    ('gen-8d797c1f12eaa613', 'science'),
    ('gen-83f00b213518e91a', 'biologie'),
    ('gen-83f00b213518e91a', 'science'),
    ('gen-d542473b4ae22abc', 'science'),
    ('gen-0cc967e582bb640b', 'science'),
    ('gen-63160c879fba16b3', 'science'),
    ('gen-83762b9c923b6599', 'anatomie'),
    ('gen-83762b9c923b6599', 'biologie'),
    ('gen-83762b9c923b6599', 'science'),
    ('gen-57b5def5cc9c5d53', 'biologie'),
    ('gen-57b5def5cc9c5d53', 'science'),
    ('gen-25442767b997579f', 'anatomie'),
    ('gen-25442767b997579f', 'biologie'),
    ('gen-25442767b997579f', 'science'),
    ('gen-b3b31fcec5d1d8f4', 'biologie'),
    ('gen-b3b31fcec5d1d8f4', 'chimie'),
    ('gen-b3b31fcec5d1d8f4', 'science'),
    ('gen-7032f2ba7babc7ac', 'biologie'),
    ('gen-7032f2ba7babc7ac', 'science'),
    ('gen-4b98dd515c622c33', 'biologie'),
    ('gen-761544a4528a09bc', 'biologie'),
    ('gen-9e5682458c36a5f9', 'biologie'),
    ('gen-0ff1de32719f67f9', 'biologie'),
    ('gen-7d1b03efb8778a46', 'astronomie'),
    ('gen-7d1b03efb8778a46', 'science'),
    ('gen-bb27c632c9c8fbd0', 'astronomie'),
    ('gen-bb27c632c9c8fbd0', 'science'),
    ('gen-c28a455ebd1308d8', 'astronomie'),
    ('gen-c28a455ebd1308d8', 'science'),
    ('gen-d909816c0a94b766', 'astronomie'),
    ('gen-d909816c0a94b766', 'science'),
    ('gen-34cfcc6c6ae91ffd', 'astronomie'),
    ('gen-34cfcc6c6ae91ffd', 'science'),
    ('gen-e3eaeae6711645f4', 'astronomie'),
    ('gen-e3eaeae6711645f4', 'science'),
    ('gen-df1523d79161c4af', 'anatomie'),
    ('gen-df1523d79161c4af', 'biologie'),
    ('gen-969209b8539c0ee8', 'anatomie'),
    ('gen-969209b8539c0ee8', 'biologie'),
    ('gen-23bd468621817c7d', 'anatomie'),
    ('gen-23bd468621817c7d', 'biologie'),
    ('gen-e0495798504e906e', 'biologie'),
    ('gen-e0495798504e906e', 'science'),
    ('gen-3f64b8318b344331', 'anatomie'),
    ('gen-3f64b8318b344331', 'biologie'),
    ('gen-7b229eaa0b514d95', 'anatomie'),
    ('gen-7b229eaa0b514d95', 'biologie'),
    ('gen-cfa71fdf50c15b75', 'anatomie'),
    ('gen-cfa71fdf50c15b75', 'biologie'),
    ('gen-f88132b385eb3016', 'biologie'),
    ('gen-f88132b385eb3016', 'science'),
    ('gen-a5dff97236d87bbd', 'biologie'),
    ('gen-a5dff97236d87bbd', 'science'),
    ('gen-84d37d98151d00f8', 'biologie'),
    ('gen-84d37d98151d00f8', 'science'),
    ('gen-b6f9a27a8676754b', 'biologie'),
    ('gen-b6f9a27a8676754b', 'science'),
    ('gen-a7786581cbccac2d', 'biologie'),
    ('gen-a7786581cbccac2d', 'science'),
    ('gen-1de81826d4226395', 'biologie'),
    ('gen-1de81826d4226395', 'science'),
    ('gen-82eefb00672aa845', 'science'),
    ('gen-42ed0522a0fb7888', 'chimie'),
    ('gen-42ed0522a0fb7888', 'science'),
    ('gen-a6da5e3f7ad50171', 'chimie'),
    ('gen-a6da5e3f7ad50171', 'science'),
    ('gen-22704c75d410f628', 'chimie'),
    ('gen-22704c75d410f628', 'science'),
    ('gen-1a9be1f19ac02bee', 'chimie'),
    ('gen-1a9be1f19ac02bee', 'science'),
    ('gen-f95e32096234606c', 'chimie'),
    ('gen-f95e32096234606c', 'science'),
    ('gen-124eb9b74902e4f3', 'chimie'),
    ('gen-124eb9b74902e4f3', 'science'),
    ('gen-7cdd54f90b6857ec', 'chimie'),
    ('gen-7cdd54f90b6857ec', 'science'),
    ('gen-b97bbddcc4c7b067', 'chimie'),
    ('gen-b97bbddcc4c7b067', 'science'),
    ('gen-99664222a59704c1', 'chimie'),
    ('gen-99664222a59704c1', 'science'),
    ('gen-259ac1cdf458f5ea', 'chimie'),
    ('gen-259ac1cdf458f5ea', 'science'),
    ('gen-1ca978b9cfaf495e', 'chimie'),
    ('gen-1ca978b9cfaf495e', 'science'),
    ('gen-fc39deef96320bdc', 'chimie'),
    ('gen-fc39deef96320bdc', 'science')
) AS l("sourceId", "slug")
JOIN "Question" q ON q."sourceId" = l."sourceId"
JOIN "Tag" t ON t."slug" = l."slug"
ON CONFLICT DO NOTHING;
