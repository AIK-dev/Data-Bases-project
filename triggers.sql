set schema FN45449;

--1 При изтриване на  User пренасочва всички негови продажби към Admin.
CREATE TRIGGER REDIRECT_SALES
AFTER DELETE ON FN45449.USERS
REFERENCING OLD AS O
FOR EACH ROW
BEGIN ATOMIC
    UPDATE FN45449.SALES S
        SET S.USERID= 1 where S.USERID = O.USERID;
END;

--2 Не позволява изтриването на първия потребител, който се явява администратор.
CREATE TRIGGER PREVENT_DELETE_OF_ADMIN
BEFORE DELETE ON USERS
REFERENCING OLD AS O
FOR EACH ROW
WHEN ( O.USERID=1 )
    BEGIN ATOMIC
        SIGNAL SQLSTATE '70002' ('Attempt to delete the Admin!');
    END;

--3/ За клиент, от който имаме приходи над 10000 правим 12% отстъпка
--Използва се UDF написана с цел да се използва в този тригер.
--Функцията получава даден запис на продаден продукт и проследява клиента, закупил стоката
--и проверява оборота от него
CREATE TRIGGER LOYAL_CLIENT_DISCOUNT
BEFORE INSERT ON FN45449.PRODUCTS_SOLD
REFERENCING NEW AS N
FOR EACH ROW
WHEN ( FN45449.TRACE_CLIENT_AND_CHECK_INCOME(N.REGID)>10000)
    BEGIN ATOMIC
        SET N.TOTALPRICE=N.TOTALPRICE-N.TOTALPRICE*0.12;
    END ;


--4. After update за клиенти ако се промени ИН по ДДС и е различно от празен стринг, да се
--премахнат първите два символа от него и да се запише в ЕИК.
--**промяна на ЕИК->запис в ИН по ДДс
CREATE OR REPLACE TRIGGER FN45449.UIC_CHECK
BEFORE UPDATE OF COMPANY_UIC ON FN45449.CLIENTS
REFERENCING NEW AS N OLD AS O
FOR EACH ROW
    WHEN (O.COMPANY_UIC <> N.COMPANY_UIC)
        BEGIN ATOMIC
            DECLARE NEW_VAT VARCHAR(30);
            SET NEW_VAT= 'BG'||CHAR(N.COMPANY_UIC);
            SET N.VAT=NEW_VAT;
        END;

--5 Забранява изтриването на продажби обработени от служители, които не са админ.
CREATE OR REPLACE TRIGGER TRIG_NO_EMPLOYEE_REPAIRS
BEFORE DELETE ON FN45449.SALES
REFERENCING OLD AS O
FOR EACH ROW MODE DB2SQL
    WHEN ( O.USERID<>1 )
        BEGIN ATOMIC
            SIGNAL SQLSTATE '70001' ('Unauthorised delete on Sales!');
        END;

--6 При изтриване на дадена продажба изтрива и артикулите асоциирани с нея
CREATE OR REPLACE TRIGGER TRIG_DELETE_PRODUCTS_IN_SALE
AFTER DELETE ON SALES
REFERENCING OLD AS O
FOR EACH ROW
    BEGIN
        DELETE FROM PRODUCTS_SOLD AS PS WHERE PS.SALEID=O.SALEID;
    END;

--7 Въвежда намаление според бройката купена стока
CREATE TRIGGER TRIG_DISCOUNT_ALT
BEFORE INSERT ON PRODUCTS_SOLD
REFERENCING NEW AS N
FOR EACH ROW
WHEN ( N.QUANTITY>100)
BEGIN
    SET N.TOTALPRICE=N.TOTALPRICE-N.TOTALPRICE*0.1;
END;

