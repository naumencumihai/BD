-- COMM
/*
COMM

FORMAT DATA: DD-MMM-YY
*/

CREATE TABLE STRADA(
	ID_STRADA NUMBER(4),
	DENUMIRE VARCHAR2(30),
	NR_IMOBILE NUMBER(3),
	CONSTRAINT PK_STRADA PRIMARY KEY(ID_STRADA)
	);
	DESC STRADA

CREATE TABLE IMOBIL(
	ID_IMOBIL NUMBER(5) PRIMARY KEY,
	DENUMIRE VARCHAR2(10),
	ID_STRAD NUMBER(4),
	NUMAR NUMBER(4),
	DATA_CONSTRUCTIE DATE,
	CONSTRAINT FK_IMOBIL_STRADA FOREIGN KEY(ID_STRAD)
	REFERENCES STRADA(ID_STRADA)
	);
	DESC IMOBIL

INSERT INTO STRADA(ID_STRADA, DENUMIRE, NR_IMOBILE)
VALUES (1, 'STRADA NR. 1', 20);

INSERT INTO STRADA VALUES (2, 'STRADA NR. 2', 15);

INSERT INTO strada (ID_STRADA, DENUMIRE)
VALUES (3, 'STRADA 3');

SELECT * FROM STRADA;

SELECT DENUMIRE, NR_IMOBILE FROM STRADA;

INSERT INTO IMOBIL 
VALUES (1, 'IMOBIL 1', 2, 19, TO_DATE('09-03-2022', 'DD-MM-YYYY'));

DROP TABLE IMOBIL;
DROP TABLE STRADA;
