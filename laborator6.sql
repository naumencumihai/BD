-- SAPT DE PASTE LIBER (RECUPERARI)

DESC EMP
DESC DEPT

-- INNER JOIN
SELECT A.ENAME, B.DNAME 
	FROM EMP A, DEPT B
	WHERE 
		A.DEPTNO = B.DEPTNO;

-- OUTER JOIN
-- 	1 (SPECIFIC ORACLE)
SELECT A.ENAME, B.DNAME 
	FROM EMP A, DEPT B
	WHERE 
		A.DEPTNO(+) = B.DEPTNO;

-- 	2 | 3 TIPURI:
--	RIGHT OUTER JOIN, LEFT OUTER JOIN, FULL OUTER JOIN
-- 	(EXEMPLE IN LABORATORUL 5)

-- 	LEFT (TABELA MAI BOGATA IN STANGA)
SELECT A.ENAME, B.DNAME 
	FROM DEPT B LEFT OUTER JOIN EMP A
	ON A.DEPTNO = B.DEPTNO;

-- === FUNCTII ===
-- FLOOR, CEIL
-- MOD (MODULO)

SELECT ENAME, EMPNO
	FROM EMP
	WHERE	
		MOD(EMPNO, 2) = 1;

-- ROUND (15.65) = 16
-- TRUNK (15.65) = 15

-- SYS.DUAL (TABELA DEFAULT - DUMMY)
SELECT ROUND (15.65, 1) FROM SYS.DUAL;
-- ROUND (_, X), X - CATE ZECIMALE
SELECT ROUND (15.65, -1) FROM SYS.DUAL;

-- SUBIECT: 
-- SA SE SELECTEZE PT FIECARE ANGAJAT, NUMELE SALARIUL
-- SALARIUL IMPARTIT LA 3, 
-- VALOAREA INTREAGA DIN SAL IMPARTIT LA 3
-- VALOAREA ROTUNJITA LA SUTE DIN SAL IMPARTIT LA 3
-- VALOAREA ROTUNJITA LA SUTIMI DIN SAL IMPARTIT LA 3


SELECT ENAME, SAL, SAL / 3, FLOOR (SAL / 3), ROUND (SAL / 3, -2), ROUND (SAL / 3, 2)
	FROM EMP;


-- CREATI O LISTA IN CARE SA FIE CALCULATA O PRIMA PT TOTI ANG
-- CARE NU PRIMESC COMISION, NU AU FUNCTIA DE MANAGER SI S-AU ANGAJAT INAINTE
-- DE ALAN 
-- PRIMA(23% DIN VENITUL LUNAR AL ANGAJATULUI, IN VALOARE ROTUNJITA LA INTREGI)
-- VETI AFISA NUMELE, FUNCTIA, COMISIONUL, DATA ANGAJARII, DATA ANGAJARII LUI ALAN SI PRIMA CALCULATA

SELECT A.ENAME, A.JOB, A.COMM, A.HIREDATE, B.HIREDATE ALLEN,
	ROUND(0.23 * (A.SAL + NVL(A.COMM, 0))) PRIMA
	FROM EMP A, EMP B
	WHERE
		B.ENAME LIKE 'ALLEN'
		AND
		A.HIREDATE < B.HIREDATE
		AND
		NVL(A.COMM, 0) = 0
		AND
		A.JOB != 'MANAGER';

SELECT A.ENAME, A.JOB, A.COMM, A.HIREDATE, B.HIREDATE ALLEN,
	ROUND(0.23 * (A.SAL + NVL(A.COMM, 0))) PRIMA
	FROM EMP A, EMP B
	WHERE
		B.ENAME = 'ALLEN'
		AND
		A.HIREDATE < B.HIREDATE
		AND
		(NVL(A.COMM, 0) = 0)
		AND
		A.JOB NOT LIKE 'MANAGER';

-- == FUNCTII DE STRING-URI ==
-- LENGTH
-- SUBSTR
-- REPLACE
-- TRANSLATE

SELECT REPLACE ('PRIMAVARA', 'MAV', 'XYZ') FROM SYS.DUAL;
-- MAV -> XYZ
SELECT TRANSLATE ('PRIMAVARA','MAV', 'XYZ') FROM SYS.DUAL;
-- M -> X; A -> Y; V -> Z
SELECT REPLACE ('PRIMAVARA', 'MAV', '') FROM SYS.DUAL;
-- STERGE 'MAV'
SELECT TRANSLATE ('PRIMAVARA','MAV', 'XY') FROM SYS.DUAL;

-- SA SE SELECTEZE PT FIECARE ANGAJAT
-- NR DE APARITII AL ULTIMELOR 2 LITERE DIN NUMELE SAU IN JOBUL SAU

SELECT ENAME, JOB,
	SUBSTR(ENAME, -2) ULTIMELE,
	REPLACE(JOB, SUBSTR(ENAME, -2), '') JOBSCURT,
	(LENGTH(JOB) - LENGTH(REPLACE(JOB, SUBSTR(ENAME, -2), ''))) / 2 NRAPARITII
FROM EMP;

-- == FUNCTII DE DATE ==
-- TO_DATE
-- TO_CAHR
-- LAST_DAY(D) -- ULTIMA ZI DIN LUNA
-- NEXT_DAY(D, 'MONDAY')

SELECT LAST_DAY(SYSDATE) LAST_DAY, NEXT_DAY(SYSDATE, 'WEDNESDAY') NEXT_DAY 
FROM SYS.DUAL;

-- EXTRACT FROM (RETURNEAZA NUMAR)
SELECT 
	EXTRACT(DAY FROM SYSDATE) ZI,
	EXTRACT(MONTH FROM SYSDATE) LUNA,
	EXTRACT(YEAR FROM SYSDATE) AN
FROM SYS.DUAL;

SELECT A.ENAME, A.HIREDATE, 'VECHI' VECHIME
FROM EMP A
WHERE
	EXTRACT(YEAR FROM HIREDATE) <= 1982
UNION
SELECT A.ENAME, A.HIREDATE, 'NOU' VECHIME
FROM EMP A
WHERE
	EXTRACT(YEAR FROM HIREDATE) > 1982
ORDER BY 1;




-- EXERCITIU
-- SA SE SELECTEZE NUMELE SEFILOR ANGAJATILOR
-- DINTR-UN DEPT CITIT DE LA TASTATURA
-- CARE AU UN VENIT MAI MARE DECAT 'BLAKE'
-- VETI AFISA NUMELE SEFULUI, NUMELE ANGAJATULUI
-- SALARIUL ANGAJATULUI ROTUNJIT LA ZECI
-- COMISIONUL ANGAJATULUI ROTUNJIT LA SUTE
-- 2 FELURI
DESC EMP

-- 1
SELECT A.ENAME SEF, B.ENAME ANGAJAT, ROUND(B.SAL, -1) SAL, ROUND(B.COMM, -2) SAL2
FROM EMP A, EMP B, DEPT C, EMP D
WHERE 
	B.MGR = A.EMPNO
	AND
	B.DEPTNO = C.DEPTNO
	AND
	C.DNAME = '&DEPARTAMENT'
	AND
	D.ENAME = 'BLAKE'
	AND
	(B.SAL + NVL(B.COMM, 0)) > (D.SAL + NVL(D.COMM, 0));

-- 2
SELECT A.ENAME SEF, B.ENAME ANGAJAT, ROUND(B.SAL, -1) SAL, ROUND(B.COMM, -2) SAL2
FROM EMP A JOIN EMP B
ON B.MGR = A.EMPNO, DEPT C, EMP D
WHERE 
	B.DEPTNO = C.DEPTNO
	AND
	C.DNAME = '&&DEPARTAMENT2'
	AND
	D.ENAME = 'BLAKE'
	AND
	(B.SAL + NVL(B.COMM, 0)) > (D.SAL + NVL(D.COMM, 0));

UNDEFINE DEPARTAMENT2