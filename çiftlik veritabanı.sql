CREATE DATABASE IF NOT EXISTS ALKAN_TARIM;
USE ALKAN_TARIM;

CREATE TABLE IF NOT EXISTS ALKAN_ÇİFTÇİLER (
    ÇİFTÇİ_ID        VARCHAR(50)    NOT NULL,
    ÇİFTÇİ_ADI       VARCHAR(50)    NOT NULL,
    ÇİFTÇİ_SOYADI    VARCHAR(50)    NOT NULL,
    ÇİFTÇİ_TELNO     INT(11)        NOT NULL,
    ÇİFTÇİ_ADRESİ    VARCHAR(250)   NOT NULL,
    PRIMARY KEY(ÇİFTÇİ_ID)
);

CREATE TABLE IF NOT EXISTS ALKAN_MAHSULLER (
    MAHSUL_ID      VARCHAR(50)    NOT NULL,
    MAHSUL_ADI     VARCHAR(50)    NOT NULL,
    NAHSUL_FIYATI  INT(50)        NOT NULL,
    PRIMARY KEY(MAHSUL_ID)
);

CREATE TABLE IF NOT EXISTS ALKAN_TARLALAR (
    TARLA_ID        VARCHAR(50)    NOT NULL,
    TARLA_ADI       VARCHAR(50)    NOT NULL,
    MAHSUL_ID       VARCHAR(50)    NOT NULL,
    MAHSUL_ADI      VARCHAR(50)    NOT NULL,
    EDILEN_MASRAF   INT(25)        NOT NULL,
    PRIMARY KEY(TARLA_ID),
    FOREIGN KEY(MAHSUL_ID) REFERENCES ALKAN_MAHSULLER(MAHSUL_ID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY(MAHSUL_ADI) REFERENCES ALKAN_MAHSULLER(MAHSUL_ADI) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS ALKAN_HAYVANLAR (
    HAYVAN_ID           VARCHAR(50)    NOT NULL,
    HAYVAN_ADI          VARCHAR(50)    NOT NULL,
    HAYVAN_TÜRÜ         VARCHAR(199)   NOT NULL,
    HAYVAN_DOĞDUĞUYIL   DATETIME       NOT NULL,
    PRIMARY KEY(HAYVAN_ID)
);

DELIMITER $$

CREATE PROCEDURE ALKAN_ÇİFTÇİLERHEPSİ ()
BEGIN
    SELECT 
        ÇİFTÇİ_ID       AS ID,
        ÇİFTÇİ_ADI      AS Adı,
        ÇİFTÇİ_SOYADI   AS Soyadı,
        ÇİFTÇİ_TELNO    AS Telefon, 
        ÇİFTÇİ_ADRESİ   AS Adres
    FROM ALKAN_ÇİFTÇİLER;
END $$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE ALKAN_ÇİFTÇİEKLE(
    id      VARCHAR(64),
    ad      VARCHAR(64),
    soy     VARCHAR(64),
    tel     INT(11),
    adr     VARCHAR(250)
)
BEGIN
    INSERT INTO ALKAN_ÇİFTÇİLER
    VALUES  (id, ad, soy, tel, adr);
END $$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE ALKAN_ÇİFTÇİLERGÜNCELLE (
    id      VARCHAR(64),
    ad      VARCHAR(64),
    soy     VARCHAR(64),
    tel     INT(11),
    adr     VARCHAR(250)
)
BEGIN
    UPDATE ALKAN_ÇİFTÇİLER
    SET 
        ÇİFTÇİ_ADI      = ad,
        ÇİFTÇİ_SOYADI   = soy,
        ÇİFTÇİ_TELNO    = tel,
        ÇİFTÇİ_ADRESİ   = adr
    WHERE 
        ÇİFTÇİ_ID       = id;
END $$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE ALKAN_ÇİFTÇİSİL(
    id      VARCHAR(64)
)
BEGIN
    DELETE FROM ALKAN_ÇİFTÇİLER
    WHERE   ÇİFTÇİ_ID = id;
END $$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE ALKAN_ÇİFTÇİBUL(
    filtre  VARCHAR(32)
)
BEGIN
    SELECT * FROM ALKAN_ÇİFTÇİLER
    WHERE 
        ÇİFTÇİ_ID       LIKE  CONCAT('%',filtre,'%') OR
        ÇİFTÇİ_ADI      LIKE  CONCAT('%',filtre,'%') OR
        ÇİFTÇİ_SOYADI   LIKE  CONCAT('%',filtre,'%') OR
        ÇİFTÇİ_TELNO    LIKE  CONCAT('%',filtre,'%') OR
        ÇİFTÇİ_ADRESİ   LIKE  CONCAT('%',filtre,'%');
END $$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE ALKAN_TARLALARHEPSİ ()
BEGIN
    SELECT * FROM ALKAN_TARLALAR;
END $$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE ALKAN_TARLAELKE(
    id          VARCHAR(64),
    tad         VARCHAR(250),
    mid         VARCHAR(50),
    madi        VARCHAR(50),
    masraf      INT(25)
)
BEGIN
    INSERT INTO ALKAN_TARLALAR
    VALUES  (id, tad, mid, madi, masraf);
END $$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE ALKAN_TARLAGÜNCELLE(
    id          VARCHAR(64),
    tad         VARCHAR(50),
    mid         VARCHAR(50),
    madi        VARCHAR(50),
    masraf      INT(25)
)
BEGIN
    UPDATE ALKAN_TARLALAR
    SET 
        TARLA_ADI       = tad,
        MAHSUL_ID       = mid,
        EDILEN_MASRAF   = masraf,
        MAHSUL_ADI      = madi
    WHERE 
        TARLA_ID       = id;
END $$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE ALKAN_TARLASİL(
    id          VARCHAR(64)
)
BEGIN
    DELETE FROM ALKAN_TARLALAR
    WHERE TARLA_ID= id;
END $$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE ALKAN_TARLABUL (
    filtre      VARCHAR(32)
)
BEGIN
    SELECT * FROM ALKAN_TARLALAR
    WHERE 
        TARLA_ID       LIKE  CONCAT('%',filtre,'%') OR
        TARLA_ADI      LIKE  CONCAT('%',filtre,'%') OR
        EDILEN_MASRAF  LIKE  CONCAT('%',filtre,'%') OR
        MAHSUL_ADI     LIKE  CONCAT('%',filtre,'%') OR
        MAHSUL_ID      LIKE  CONCAT('%',filtre,'%');
END $$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE ALKAN_KAR_ORANI (
    çiftçi_id_param VARCHAR(50),
    tarla_id_param  VARCHAR(50)
)
BEGIN
    DECLARE maliyet INT;
    DECLARE gelir INT;
    SELECT SUM(EDILEN_MASRAF) INTO maliyet
    FROM ALKAN_TARLALAR
    WHERE TARLA_ID = tarla_id_param;
    SELECT SUM(NAHSUL_FIYATI) INTO gelir
    FROM ALKAN_TARLALAR
    JOIN ALKAN_MAHSULLER ON ALKAN_TARLALAR.MAHSUL_ID = ALKAN_MAHSULLER.MAHSUL_ID
    WHERE TARLA_ID = tarla_id_param;
    IF maliyet IS NOT NULL AND gelir IS NOT NULL THEN
        SELECT ((gelir - maliyet) / maliyet) * 100 AS KarOrani;
    ELSE
        SELECT NULL AS KarOrani;
    END IF;
END $$

DELIMITER ;
