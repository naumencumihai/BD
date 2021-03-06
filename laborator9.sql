

-- SUBCERERI PE CLAUZA SELECT --

/*
RESTRICTIE: TREBUIE SA INTOARCA INTOTDEAUNA O SINGURA
INREGISTRARE SI O SINGURA VALOARE
*/

------
/*
SA SE AFISEZE PT TOTI ANGAJATII CARE CASTIGA MAI MULT
DECAT SEFUL LOR, NUMELE, NUMELE SEFULUI SI NR DE ANGAJATI DIN
DEPT SEFULUI
*/

SELECT A.ENAME ANGAJAT, SEF.ENAME SEF, 
	(SELECT COUNT(*)
	FROM EMP B
	WHERE B.DEPTNO = SEF.DEPTNO) NUMAR
FROM EMP A JOIN EMP SEF
	ON A.MGR = SEF.EMPNO
WHERE
	A.SAL + NVL(A.COMM, 0) > SEF.SAL + NVL(SEF.COMM, 0);

/*
SA SE SELECTEZE PT FIECARE ANGAJAT DIN DEPT LUI ALEN
NUMELE, DENUMIREA DEPT SI NR DE ANGAJATI DIN FIRMA CARE
CASTIGA MAI PUTIN DECAT EL
*/

SELECT A.ENAME NUME, D.DNAME DEPT, 
	(SELECT COUNT(*)
	FROM EMP B
	WHERE B.SAL + NVL(B.COMM, 0) < A.SAL + NVL(A.COMM, 0)) NR
FROM EMP A, DEPT D, EMP ALEN
WHERE
	A.DEPTNO = D.DEPTNO
	AND
	ALEN.ENAME = 'ALLEN'
	AND
	ALEN.DEPTNO = D.DEPTNO
	AND
	ALEN.DEPTNO = A.DEPTNO;


SELECT A.ENAME, A.SAL, D.DNAME, 
	(SELECT COUNT(*)
	FROM EMP B
	WHERE B.SAL + NVL(B.COMM, 0) < A.SAL + NVL(A.COMM, 0)) NR
FROM EMP A, DEPT D
WHERE
	A.DEPTNO = D.DEPTNO;


-- SUCERERI PE CLAUZA HAVING --

SELECT A.DNAME, COUNT(*) NR
FROM DEPT A JOIN EMP B ON A.DEPTNO = B.DEPTNO
GROUP BY A.DNAME
HAVING COUNT(*) = 
	(
	SELECT MAX(COUNT(*))
	FROM EMP C 
	GROUP BY C.DEPTNO
	);

/*
SA SE SELECTEZE GRADUL SAL IN CARE SUNT SITUATE CELE MAI MULTE SALARII
DIN FIRM
VETI AFISA GRADUL SAL SI NR DE SALARIATI
*/

DESC EMP
DESC DEPT
DESC SALGRADE

SELECT A.GRADE, COUNT(B.EMPNO) NR
FROM SALGRADE A JOIN EMP B
	ON B.SAL BETWEEN A.LOSAL AND A.HISAL
GROUP BY A.GRADE
HAVING COUNT(B.EMPNO) = 
	(
	SELECT MAX(COUNT(C.EMPNO))
	FROM EMP C JOIN SALGRADE S
		ON C.SAL BETWEEN S.LOSAL AND S.HISAL
	GROUP BY S.GRADE
	);

/*
SA SE AFLE CARE ESTE DEPT IN CARE AU VENIT CEI MAI MULTI ANGAJATI
IN ACELASI AN
*/

SELECT A.DNAME, TO_CHAR(B.HIREDATE, 'YYYY') AN, COUNT(*) NR
FROM EMP B JOIN DEPT A 
	ON B.DEPTNO = A.DEPTNO
GROUP BY A.DNAME, TO_CHAR(B.HIREDATE, 'YYYY')
HAVING COUNT(*) = 
	(
	SELECT MAX(COUNT(*))
	FROM EMP C
	GROUP BY C.DEPTNO, TO_CHAR(C.HIREDATE, 'YYYY')
	);


-- SUBCERERI PE CLAUZA ORDER BY --

/*
SA SE AFISEZE TOTI ANG DIN EMP IN FUNCTIE DE MARIMEA DEPT
DIN CARE FAC PARTE
*/

SELECT A.ENAME, A.DEPTNO
FROM EMP A
ORDER BY 
	(
	SELECT COUNT(*)
	FROM EMP C
	WHERE 
		C.DEPTNO = A.DEPTNO
	) DESC;

/*
OPERATORI
=			!=
IN 			NOT
LIKE		NOT LIKE
ANY			SOME
EXISTS		NOT EXISTS

EXISTS, NOT EXISTS INTORC BOOLEAN
*/

--PT FIECARE DEPT SA SE AFISEZE ANGAJATUL CU CEL MAI MARE SAL

SELECT A.ENAME, D.DNAME, A.SAL
FROM EMP A JOIN DEPT D
	ON A.DEPTNO = D.DEPTNO
WHERE
	NOT EXISTS
	(
	SELECT C.SAL
	FROM EMP C
	WHERE
		C.SAL > A.SAL
		AND
		C.DEPTNO = A.DEPTNO
	);


/*
TEST
SA SE SELECTEZE CARE SUNT SEFII DIN FIRMA
CARE AU CEI MAI PUTINI SUBORDONATI DIRECT
SE VOR ELIMINA SCOTT SI ALLEN DIN ACEASTA CAUTARE
*/

DESC EMP
DESC DEPT


SELECT SEF.ENAME, COUNT(ANG.EMPNO) NR
FROM EMP SEF JOIN EMP ANG
	ON SEF.EMPNO = ANG.MGR
WHERE 
	SEF.ENAME != 'SCOTT'
	AND
	SEF.ENAME != 'ALLEN'
GROUP BY SEF.ENAME
HAVING COUNT(ANG.EMPNO) = 
	(
	SELECT MIN(COUNT(C.EMPNO))
	FROM EMP C
	WHERE 
		C.ENAME != 'SCOTT'
		AND
		C.ENAME != 'ALLEN'
	GROUP BY C.MGR
	);