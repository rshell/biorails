
prompt =========================================================================
prompt Script to reset all the Data Format in a Biorails Installation
prompt =========================================================================
prompt Created on 14 May 2008 by rshell
set feedback off
set define off

prompt Disabling triggers for DATA_FORMATS...
alter table DATA_FORMATS disable all triggers;

prompt Deleting all existing DATA_FORMATS...
delete from DATA_FORMATS;

prompt Loading DATA_FORMATS...
insert into DATA_FORMATS
  (ID,
   NAME,
   DESCRIPTION,
   DEFAULT_VALUE,
   FORMAT_REGEX,
   LOCK_VERSION,
   CREATED_AT,
   UPDATED_AT,
   DATA_TYPE_ID,
   UPDATED_BY_USER_ID,
   CREATED_BY_USER_ID,
   FORMAT_SPRINTF)
values
  (1,
   'Text',
   'Free Format Text',
   null,
   '(.*)',
   4,
   to_date('24-08-2007 12:37:02', 'dd-mm-yyyy hh24:mi:ss'),
   to_date('12-05-2008 00:20:17', 'dd-mm-yyyy hh24:mi:ss'),
   1,
   1,
   1,
   null);
   
insert into DATA_FORMATS
  (ID,
   NAME,
   DESCRIPTION,
   DEFAULT_VALUE,
   FORMAT_REGEX,
   LOCK_VERSION,
   CREATED_AT,
   UPDATED_AT,
   DATA_TYPE_ID,
   UPDATED_BY_USER_ID,
   CREATED_BY_USER_ID,
   FORMAT_SPRINTF)
values
  (2,
   'Alpha',
   'A-Z',
   null,
   '^[A-Z]*$',
   7,
   to_date('24-08-2007 12:37:02', 'dd-mm-yyyy hh24:mi:ss'),
   to_date('12-05-2008 00:20:17', 'dd-mm-yyyy hh24:mi:ss'),
   1,
   1,
   1,
   null);
   
insert into DATA_FORMATS
  (ID,
   NAME,
   DESCRIPTION,
   DEFAULT_VALUE,
   FORMAT_REGEX,
   LOCK_VERSION,
   CREATED_AT,
   UPDATED_AT,
   DATA_TYPE_ID,
   UPDATED_BY_USER_ID,
   CREATED_BY_USER_ID,
   FORMAT_SPRINTF)
values
  (3,
   'Line',
   'Single Line of Text',
   null,
   '[^"\r\n]*',
   2,
   to_date('24-08-2007 12:37:02', 'dd-mm-yyyy hh24:mi:ss'),
   to_date('12-05-2008 00:20:17', 'dd-mm-yyyy hh24:mi:ss'),
   1,
   1,
   1,
   null);
   
insert into DATA_FORMATS
  (ID,
   NAME,
   DESCRIPTION,
   DEFAULT_VALUE,
   FORMAT_REGEX,
   LOCK_VERSION,
   CREATED_AT,
   UPDATED_AT,
   DATA_TYPE_ID,
   UPDATED_BY_USER_ID,
   CREATED_BY_USER_ID,
   FORMAT_SPRINTF)
values
  (4,
   'Rational',
   'Standard Number format +/-nnn.nnnnn ',
   '0.0',
   '^[-+]?[0-9]*[\.,]?[0-9]*',
   10,
   to_date('27-11-2006 11:59:22', 'dd-mm-yyyy hh24:mi:ss'),
   to_date('12-05-2008 00:20:17', 'dd-mm-yyyy hh24:mi:ss'),
   2,
   1,
   1,
   '%g');

insert into DATA_FORMATS
  (ID,
   NAME,
   DESCRIPTION,
   DEFAULT_VALUE,
   FORMAT_REGEX,
   LOCK_VERSION,
   CREATED_AT,
   UPDATED_AT,
   DATA_TYPE_ID,
   UPDATED_BY_USER_ID,
   CREATED_BY_USER_ID,
   FORMAT_SPRINTF)
values
  (5,
   'Rational.Eng',
   'Standard Number format +/-nnn.nnnnn ',
   '0.0',
   '^[-+]?[0-9]*[\.]?[0-9]*',
   10,
   to_date('27-11-2006 11:59:22', 'dd-mm-yyyy hh24:mi:ss'),
   to_date('12-05-2008 00:20:17', 'dd-mm-yyyy hh24:mi:ss'),
   2,
   1,
   1,
   '%g');

insert into DATA_FORMATS
  (ID,
   NAME,
   DESCRIPTION,
   DEFAULT_VALUE,
   FORMAT_REGEX,
   LOCK_VERSION,
   CREATED_AT,
   UPDATED_AT,
   DATA_TYPE_ID,
   UPDATED_BY_USER_ID,
   CREATED_BY_USER_ID,
   FORMAT_SPRINTF)
values
  (6,
   'Rational.Euro',
   'Standard Number format +/-nnn.nnnnn ',
   '0.0',
   '^[-+]?[0-9]*[,]?[0-9]*',
   10,
   to_date('27-11-2006 11:59:22', 'dd-mm-yyyy hh24:mi:ss'),
   to_date('12-05-2008 00:20:17', 'dd-mm-yyyy hh24:mi:ss'),
   2,
   1,
   1,
   '%g');

insert into DATA_FORMATS
  (ID,
   NAME,
   DESCRIPTION,
   DEFAULT_VALUE,
   FORMAT_REGEX,
   LOCK_VERSION,
   CREATED_AT,
   UPDATED_AT,
   DATA_TYPE_ID,
   UPDATED_BY_USER_ID,
   CREATED_BY_USER_ID,
   FORMAT_SPRINTF)
values
  (7,
   'Scientific Notation',
   'Scientific Notation',
   null,
   '[-+]?[0-9]*[\.,]?[0-9]+([eE][-+]?[0-9]+)?',
   2,
   to_date('24-08-2007 12:37:02', 'dd-mm-yyyy hh24:mi:ss'),
   to_date('12-05-2008 00:20:17', 'dd-mm-yyyy hh24:mi:ss'),
   2,
   1,
   1,
   null);


insert into DATA_FORMATS
  (ID,
   NAME,
   DESCRIPTION,
   DEFAULT_VALUE,
   FORMAT_REGEX,
   LOCK_VERSION,
   CREATED_AT,
   UPDATED_AT,
   DATA_TYPE_ID,
   UPDATED_BY_USER_ID,
   CREATED_BY_USER_ID,
   FORMAT_SPRINTF)
values
  (8,
   'Integer',
   'Integer Value',
   null,
   '[-+]?\b\d+\b',
   5,
   to_date('24-08-2007 12:37:02', 'dd-mm-yyyy hh24:mi:ss'),
   to_date('12-05-2008 00:20:17', 'dd-mm-yyyy hh24:mi:ss'),
   2,
   1,
   1,
   '%d');
   
   
insert into DATA_FORMATS
  (ID,
   NAME,
   DESCRIPTION,
   DEFAULT_VALUE,
   FORMAT_REGEX,
   LOCK_VERSION,
   CREATED_AT,
   UPDATED_AT,
   DATA_TYPE_ID,
   UPDATED_BY_USER_ID,
   CREATED_BY_USER_ID,
   FORMAT_SPRINTF)
values
  (11,
   'Positive',
   'Description:  Positive integer value',
   null,
   '^[0-9]*',
   3,
   to_date('24-08-2007 12:37:02', 'dd-mm-yyyy hh24:mi:ss'),
   to_date('12-05-2008 00:20:17', 'dd-mm-yyyy hh24:mi:ss'),
   2,
   1,
   1,
   null);
   
   
insert into DATA_FORMATS
  (ID,
   NAME,
   DESCRIPTION,
   DEFAULT_VALUE,
   FORMAT_REGEX,
   LOCK_VERSION,
   CREATED_AT,
   UPDATED_AT,
   DATA_TYPE_ID,
   UPDATED_BY_USER_ID,
   CREATED_BY_USER_ID,
   FORMAT_SPRINTF)
values
  (12,
   'Decimal5.2',
   'Description: validates to 5 digits and 2 decimal places but not allowing zero',
   null,
   '^\d{1,5}([\.,]\d{1,2})?$',
   4,
   to_date('24-08-2007 12:37:02', 'dd-mm-yyyy hh24:mi:ss'),
   to_date('12-05-2008 00:20:17', 'dd-mm-yyyy hh24:mi:ss'),
   2,
   1,
   1,
   '%g');
   
insert into DATA_FORMATS
  (ID,
   NAME,
   DESCRIPTION,
   DEFAULT_VALUE,
   FORMAT_REGEX,
   LOCK_VERSION,
   CREATED_AT,
   UPDATED_AT,
   DATA_TYPE_ID,
   UPDATED_BY_USER_ID,
   CREATED_BY_USER_ID,
   FORMAT_SPRINTF)
values
  (13,
   'Percentage',
   'Description:  Percentage (From 0 to 100)',
   null,
   '[-+]?[0-9]*[\.,]?[0-9]*',
   3,
   to_date('24-08-2007 12:37:02', 'dd-mm-yyyy hh24:mi:ss'),
   to_date('12-05-2008 00:20:17', 'dd-mm-yyyy hh24:mi:ss'),
   2,
   1,
   1,
   '%d');
   
insert into DATA_FORMATS
  (ID,
   NAME,
   DESCRIPTION,
   DEFAULT_VALUE,
   FORMAT_REGEX,
   LOCK_VERSION,
   CREATED_AT,
   UPDATED_AT,
   DATA_TYPE_ID,
   UPDATED_BY_USER_ID,
   CREATED_BY_USER_ID,
   FORMAT_SPRINTF)
values
  (14,
   'URL',
   'Description:  valid URLs, whether they had HTTP in front or not. ',
   null,
   '(http://)[a..Z]*',
   3,
   to_date('24-08-2007 12:37:02', 'dd-mm-yyyy hh24:mi:ss'),
   to_date('12-05-2008 00:20:17', 'dd-mm-yyyy hh24:mi:ss'),
   6,
   1,
   1,
   null);
   
insert into DATA_FORMATS
  (ID,
   NAME,
   DESCRIPTION,
   DEFAULT_VALUE,
   FORMAT_REGEX,
   LOCK_VERSION,
   CREATED_AT,
   UPDATED_AT,
   DATA_TYPE_ID,
   UPDATED_BY_USER_ID,
   CREATED_BY_USER_ID,
   FORMAT_SPRINTF)
values
  (15,
   'Name',
   'Name without spaces',
   null,
   '^[A-Z,a-z,0-9]*$',
   4,
   to_date('25-05-2007 21:07:28', 'dd-mm-yyyy hh24:mi:ss'),
   to_date('12-05-2008 00:20:17', 'dd-mm-yyyy hh24:mi:ss'),
   1,
   1,
   1,
   null);
   
insert into DATA_FORMATS
  (ID,
   NAME,
   DESCRIPTION,
   DEFAULT_VALUE,
   FORMAT_REGEX,
   LOCK_VERSION,
   CREATED_AT,
   UPDATED_AT,
   DATA_TYPE_ID,
   UPDATED_BY_USER_ID,
   CREATED_BY_USER_ID,
   FORMAT_SPRINTF)
values
  (16,
   'Quantiy',
   'Basic numeric value followed by a unit',
   null,
   '^[-+]?[0-9]*[\.,]?[0-9]+[ ,A-z,/,%]*',
   3,
   to_date('06-06-2007 20:15:15', 'dd-mm-yyyy hh24:mi:ss'),
   to_date('12-05-2008 00:20:17', 'dd-mm-yyyy hh24:mi:ss'),
   2,
   1,
   1,
   '%d');
   
insert into DATA_FORMATS
  (ID,
   NAME,
   DESCRIPTION,
   DEFAULT_VALUE,
   FORMAT_REGEX,
   LOCK_VERSION,
   CREATED_AT,
   UPDATED_AT,
   DATA_TYPE_ID,
   UPDATED_BY_USER_ID,
   CREATED_BY_USER_ID,
   FORMAT_SPRINTF)
values
  (17,
   'Concentration',
   'Concentration with units of mM,uM,nM,pM,',
   null,
   '^[-+]?[0-9]*[\.,]?[0-9]* ?[m,u,n,p]?M?',
   5,
   to_date('06-06-2007 20:20:26', 'dd-mm-yyyy hh24:mi:ss'),
   to_date('12-05-2008 00:20:17', 'dd-mm-yyyy hh24:mi:ss'),
   2,
   1,
   1,
   '%g');
   
insert into DATA_FORMATS
  (ID,
   NAME,
   DESCRIPTION,
   DEFAULT_VALUE,
   FORMAT_REGEX,
   LOCK_VERSION,
   CREATED_AT,
   UPDATED_AT,
   DATA_TYPE_ID,
   UPDATED_BY_USER_ID,
   CREATED_BY_USER_ID,
   FORMAT_SPRINTF)
values
  (18,
   'Amount_g',
   'Amount in grams of stuff with mg,kg,g,ug,ng,pg units ',
   null,
   '^[-+]?[0-9]*[\.,]?[0-9] ?[(k,m,u,n,p)]g?',
   3,
   to_date('06-06-2007 20:22:12', 'dd-mm-yyyy hh24:mi:ss'),
   to_date('12-05-2008 00:20:17', 'dd-mm-yyyy hh24:mi:ss'),
   2,
   1,
   1,
   '%d');

   
insert into DATA_FORMATS
  (ID,
   NAME,
   DESCRIPTION,
   DEFAULT_VALUE,
   FORMAT_REGEX,
   LOCK_VERSION,
   CREATED_AT,
   UPDATED_AT,
   DATA_TYPE_ID,
   UPDATED_BY_USER_ID,
   CREATED_BY_USER_ID,
   FORMAT_SPRINTF)
values
  (19,
   'file',
   'file',
   null,
   null,
   2,
   to_date('28-04-2008 21:49:36', 'dd-mm-yyyy hh24:mi:ss'),
   to_date('12-05-2008 00:20:17', 'dd-mm-yyyy hh24:mi:ss'),
   7,
   1,
   3,
   null);
   
insert into DATA_FORMATS
  (ID,
   NAME,
   DESCRIPTION,
   DEFAULT_VALUE,
   FORMAT_REGEX,
   LOCK_VERSION,
   CREATED_AT,
   UPDATED_AT,
   DATA_TYPE_ID,
   UPDATED_BY_USER_ID,
   CREATED_BY_USER_ID,
   FORMAT_SPRINTF)
values
  (20,
   'Date',
   'test',
   null,
   null,
   6,
   to_date('28-04-2008 20:12:00', 'dd-mm-yyyy hh24:mi:ss'),
   to_date('12-05-2008 00:25:21', 'dd-mm-yyyy hh24:mi:ss'),
   3,
   1,
   3,
   '%Y-%m-%d');
   
 
prompt 17 records loaded
prompt Enabling triggers for DATA_FORMATS...
alter table DATA_FORMATS enable all triggers;
set feedback on
set define on

prompt ===========================================================================================================
prompt Invalid Assay Parameters conversion
prompt 
select s.name,s.data_format_id,s.data_type_id 
from assay_parameters s
where data_type_id != 5 
and not exists (select 1 from data_formats f 
                  where f.data_type_id=s.data_type_id and f.id = s.data_format_id); 
prompt ===========================================================================================================
            
prompt =======================================================
prompt Bad Text formats converted to format 1 Text  

update assay_parameters s set data_format_id = 1
where data_type_id = 1 
and not exists (select 1 from data_formats f 
                  where f.data_type_id=s.data_type_id and f.id = s.data_format_id);

prompt =======================================================
prompt Bad Text formats converted to format 4 Rational  

update assay_parameters s set data_format_id = 4
where data_type_id = 2 
and not exists (select 1 from data_formats f 
                  where f.data_type_id=s.data_type_id and f.id = s.data_format_id); 

prompt =======================================================
prompt Bad Text formats converted to format 20 Date  

                  
update assay_parameters s set data_format_id = 20
where data_type_id = 3 
and not exists (select 1 from data_formats f 
                  where f.data_type_id=s.data_type_id and f.id = s.data_format_id); 

prompt =======================================================
prompt Bad data element converted remove format
                  
update assay_parameters s set data_format_id = null
where data_type_id = 5
and not exists (select 1 from data_formats f 
                  where f.data_type_id=s.data_type_id and f.id = s.data_format_id); 

prompt =======================================================
prompt Bad Text formats converted to format 14 Url  
                  
update assay_parameters s set data_format_id = 14
where data_type_id = 6
and not exists (select 1 from data_formats f 
                  where f.data_type_id=s.data_type_id and f.id = s.data_format_id); 

prompt =======================================================
prompt Bad Text formats converted to format 19 File  
                  
                  
update assay_parameters s set data_format_id = 19
where data_type_id = 7
and not exists (select 1 from data_formats f 
                  where f.data_type_id=s.data_type_id and f.id = s.data_format_id); 
                                           
                  
prompt ===========================================================================================================
prompt Invalid  Parameters conversion
prompt 

select s.name,s.data_format_id,s.data_type_id 
from parameters s
where data_type_id != 5 
and not exists (select 1 from data_formats f 
                  where f.data_type_id=s.data_type_id and f.id = s.data_format_id); 
prompt ===========================================================================================================

prompt =======================================================
prompt Bad Text formats converted to format 1 Text  

update parameters s set data_format_id = 1
where data_type_id = 1 
and not exists (select 1 from data_formats f 
                  where f.data_type_id=s.data_type_id and f.id = s.data_format_id);
prompt =======================================================
prompt Bad Text formats converted to format 4 Rational  

update parameters s set data_format_id = 4
where data_type_id = 2 
and not exists (select 1 from data_formats f 
                  where f.data_type_id=s.data_type_id and f.id = s.data_format_id); 

prompt =======================================================
prompt Bad Text formats converted to format 20 Date  
                  
update parameters s set data_format_id = 20
where data_type_id = 3 
and not exists (select 1 from data_formats f 
                  where f.data_type_id=s.data_type_id and f.id = s.data_format_id); 

prompt =======================================================
prompt Bad data element converted remove format
                  
update parameters s set data_format_id = null
where data_type_id = 5
and not exists (select 1 from data_formats f 
                  where f.data_type_id=s.data_type_id and f.id = s.data_format_id); 

prompt =======================================================
prompt Bad Text formats converted to format 14 Url  
                  
update parameters s set data_format_id = 14
where data_type_id = 6
and not exists (select 1 from data_formats f 
                  where f.data_type_id=s.data_type_id and f.id = s.data_format_id); 

prompt =======================================================
prompt Bad Text formats converted to format 19 File  
                  
update parameters s set data_format_id = 19
where data_type_id = 7
and not exists (select 1 from data_formats f 
                  where f.data_type_id=s.data_type_id and f.id = s.data_format_id); 
                                           
prompt =======================================================
prompt Done commit changes if you are happy
