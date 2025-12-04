SELECT 'alter index '|| index_owner ||'.'||index_name || ' monitoring usage ;' FROM kk_adm.vyg_index_usage
    where monitoring = 'NO';
    
SELECT 'alter index '|| index_owner ||'.'||index_name || ' nomonitoring usage ;' FROM kk_adm.vyg_index_usage
    where monitoring = 'NO';
    
