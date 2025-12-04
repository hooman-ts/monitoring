DECLARE
  l_credit_card_no    VARCHAR2(19) := &cardno;
 -- l_mus_id            NUMBER    :=&musid;
  l_ccn_raw           RAW(128) := UTL_RAW.cast_to_raw(l_credit_card_no);
  l_key               RAW(128) := UTL_RAW.cast_to_raw('123456789');

  l_encrypted_raw     RAW(2048);
  l_decrypted_raw     RAW(2048);
BEGIN
  DBMS_OUTPUT.put_line('Original  : ' || l_credit_card_no);


  l_encrypted_raw := DBMS_CRYPTO.encrypt(src => l_ccn_raw, 
                                         typ => DBMS_CRYPTO.des_cbc_pkcs5 , 
                                         key => l_key);

  DBMS_OUTPUT.put_line('Encrypted : ' || RAWTOHEX(UTL_RAW.cast_to_raw(l_encrypted_raw)));


  l_decrypted_raw := DBMS_CRYPTO.decrypt(src => l_encrypted_raw, 
                                         typ => DBMS_CRYPTO.des_cbc_pkcs5 , 
                                         key => l_key);

  DBMS_OUTPUT.put_line('Decrypted : ' || (l_decrypted_raw));

  
END;
/


----------------------------------------------------------
-------TABLODAN OKUYUP DECRYPTO YAP -----------------------
-----------------------------------------------------------
DECLARE
  
  l_key               RAW(128) := UTL_RAW.cast_to_raw('123456789');

  l_decrypted_raw     RAW(2048);
  
  card_enc_no RAW(2048); --UTL_RAW.cast_to_raw(l_credit_card_no);;
BEGIN
 
select UTL_RAW.cast_to_varchar2(ccard)  into  card_enc_no from card
where mus_id=2;

  l_decrypted_raw := DBMS_CRYPTO.decrypt(src => card_enc_no, 
                                         typ => DBMS_CRYPTO.des_cbc_pkcs5 , 
                                         key => l_key);

  DBMS_OUTPUT.put_line('Decrypted : ' || UTL_RAW.cast_to_varchar2(l_decrypted_raw));
  
END;
SHOW ERROR;