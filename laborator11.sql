-- NU INTRA LA COLOCVIU

-- COMENZI SPECIFICE SQL PLUS

-- SET LINES
-- SET PAGESIZE
-- SET ...

-- ACCEPT
-- DEFINE
-- UNDEFINE
-- DESC

-- TTITLE 
-- BTITLE 

SELECT 
	A.DNAME, B.ENAME, B.SAL + NVL(B.COMM, 0) VENIT,
	'      ' SEMNATURA
FROM
	EMP B JOIN DEPT A 
	ON A.DEPTNO = B.DEPTNO
ORDER BY
	A.DNAME, B.ENAME;

-- BREAK
-- COLUMN

/*
PENTRU TOTI ANG DIN DEPT CU CEI MAI PUTINI ANG,
ANGAJATI CARE NU FAC PARTE DIN GRADUL SALARIAL AL LUI KING
SA SE AFISEZE NUMELE ANGAJATULUI, DENUMIREA DEPT, GRADUL SAL
SI O APRECIERE A SALARIULUI ASTFEL, 
DACA SAL > 3000 SCRIEM BUN, DACA <= 3000 BUNICEL
*/

-- NU E CERINTA DE SUS
SELECT 
	A.ENAME, D.DNAME, G.GRADE, 
	DECODE(SIGN(A.SAL - 3000), 1, 'BUN', 'BUNICEL') APRECIERE
FROM
	EMP A JOIN DEPT D ON 
		A.DEPTNO = D.DEPTNO 
	JOIN SALGRADE G ON
		A.SAL BETWEEN G.LOSAL AND G.HISAL
WHERE
	G.GRADE IN (
				SELECT 
					B.GRADE
				FROM 
					SALGRADE B JOIN EMP C ON
						C.SAL BETWEEN B.LOSAL AND B.HISAL
				GROUP BY B.GRADE
				HAVING COUNT(*) = 
					(
					SELECT 
						MAX(COUNT(*)) 
					FROM 
						EMP JOIN SALGRADE ON 
							SAL BETWEEN LOSAL AND HISAL
					GROUP BY GRADE
					)
				)
AND
	A.DEPTNO != (
				SELECT 
					DEPTNO
				FROM
					EMP
				WHERE
					ENAME LIKE 'KING'
				);

/*

SA SE CREEZE O TABELA NUMITA ANGAJATI_ALLEN CONTINAD PRIMII 2
ANGAJATI CA MARIME A VENITURILOR LOR CE FAC PARTE DIN ACELASI
GRAD SALARIAL CU ALLEN
VETI AFISA
NUME ANGAJAT, VENIT, GRAD SALARIAL
INCLUDE SI SELECTAREA INREGISTRARILOR DIN TABELA SI STERGEREA TABELEI

*/

CREATE TABLE ANGAJATI_ALLEN
AS
SELECT 
	A.ENAME, A.SAL + NVL(A.COMM, 0) VENIT, C.GRADE
FROM
	EMP A JOIN SALGRADE C ON
		A.SAL BETWEEN C.LOSAL AND C.HISAL
WHERE
	C.GRADE = (
				SELECT B.GRADE
				FROM 
					SALGRADE B JOIN EMP AN ON
						AN.SAL BETWEEN B.LOSAL AND B.HISAL
				WHERE
					AN.ENAME LIKE 'ALLEN'
				);
DESC ANGAJATI_ALLEN

SELECT * FROM ANGAJATI_ALLEN;

DROP TABLE ANGAJATI_ALLEN;