select  to_char(BEGIN_INTERVAL_TIME,'DD.MM-HH24:MI') baslangic,
        to_char(END_INTERVAL_TIME,'DD.MM-HH24:MI') bitis,
        sq.snap_id, sq.sql_id,  sq.plan1,  st.sql_text 
        from sys.WRH$_SQLTEXT st,
             sys.WRM$_SNAPSHOT snap,
            ( select distinct s1.sql_id sql_id, s1.plan_hash_value plan1, s1.snap_id
                from sys.WRH$_SQL_PLAN S1 ,sys.WRH$_SQL_PLAN S2
                 where s1.sql_id = s2.sql_id
                    and s1.plan_hash_value <> s2.plan_hash_value
                    and s1.id =1
             )sq
            where sq.sql_id  = st.sql_id
            and sq.snap_id = snap.snap_id (+)
            and st.sql_id in ( select sql_id from (  --son 10 dakikada en cok beklemeye neden olan SQLlerin plan kaymasini kontrol eder. 
                                    select count(*) cnt, sum(time_waited) tot_time_waited, trunc(avg(time_waited)) avg_time_waited,   sql_id, event 
                                        from v$active_session_history s
                                        where sample_time > sysdate - 10/24/60
                                        group by sql_id, event 
                                        having count(*) > 1 
                                        order by sum(time_waited) desc
                                        )
                                        where rownum < 100
                              )
            order by sql_id;