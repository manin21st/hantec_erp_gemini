$PBExportHeader$w_piz2001.srw
$PBExportComments$** �޿�ȯ�漳��(1)
forward
global type w_piz2001 from w_inherite_standard
end type
type dw_list from datawindow within w_piz2001
end type
type dw_1 from datawindow within w_piz2001
end type
type rr_1 from roundrectangle within w_piz2001
end type
end forward

global type w_piz2001 from w_inherite_standard
string title = "�޿�ȯ�漳��"
dw_list dw_list
dw_1 dw_1
rr_1 rr_1
end type
global w_piz2001 w_piz2001

on w_piz2001.create
int iCurrent
call super::create
this.dw_list=create dw_list
this.dw_1=create dw_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_list
this.Control[iCurrent+2]=this.dw_1
this.Control[iCurrent+3]=this.rr_1
end on

on w_piz2001.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_list)
destroy(this.dw_1)
destroy(this.rr_1)
end on

event open;call super::open;string ls_woncode, ls_sikcode, ls_tjdaygubn
string ls_bdate, ls_pdate, ls_semuse, ls_ptongno
long ll_wonjun, ll_sikdae, ll_yjfree, ll_woljung, ll_jyhando
long ll_kun1, ll_kun1_1, ll_kun1per, ll_kun11, ll_kun2, ll_kun2_1, ll_kun2per, ll_kun22
long ll_kun3, ll_kun3_1, ll_kun3per, ll_kun33, ll_kun4, ll_kun4_1, ll_kun4per, ll_kun44
long ll_kun5, ll_kun5_1, ll_kun5per, ll_kun55
long ll_gigong,ll_baegong,ll_bugong,ll_janggong,ll_gyungong,ll_bunygong,ll_matgong,ll_sosugong1,ll_sosugong2
long ll_bohum,ll_jbohum,ll_medper, ll_medhando,ll_yuchigong,ll_cjgogong,ll_daehakgong
long ll_jutper,ll_juthando,ll_gibuhanper,ll_standgong,ll_gayunsaveper,ll_gayunsave,ll_yunsave
long ll_tujaper,ll_tujahanper,ll_cardpayper,ll_cardper,ll_cardhando
long ll_jutchper, ll_jutchong
long ll_san1, ll_san1_1, ll_san1per, ll_san11, ll_san2, ll_san2_1, ll_san2per, ll_san22
long ll_san3, ll_san3_1, ll_san3per, ll_san33, ll_san4, ll_san4_1, ll_san4per, ll_san44
long ll_sangi,ll_sanehaper,ll_sanchoper,ll_sankunhan,ll_jutseackper,ll_jangikum,ll_jangiago
long ll_tjper
long ll_tjyear1, ll_tjyear1_1, ll_tjyear1amt, ll_tjyear11
long ll_tjyear2, ll_tjyear2_1, ll_tjyear2amt, ll_tjyear22
long ll_tjyear3, ll_tjyear3_1, ll_tjyear3amt, ll_tjyear33
long ll_tjyear4, ll_tjyear4_1, ll_tjyear4amt, ll_tjyear44
long ll_tjseackhan, ll_tjseackgong
long ll_sawoo
double ld_goyungper, ld_nojoper
string amtgbn


dw_list.settransobject(sqlca)
dw_list.reset()
dw_list.insertrow(0)
dw_1.settransobject(sqlca)


SELECT SUBSTR("P0_SYSCNFG"."DATANAME",1,2)				   			/*�������������ڵ�*/
INTO :ls_woncode  
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND ( "P0_SYSCNFG"."SERIAL" = 28 ) AND ( "P0_SYSCNFG"."LINENO" = '1' )   ;


SELECT TO_NUMBER(SUBSTR("P0_SYSCNFG"."DATANAME",3,8))				   			/*��������*/
INTO :ll_wonjun  
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND ( "P0_SYSCNFG"."SERIAL" = 28 ) AND ( "P0_SYSCNFG"."LINENO" = '1' )   ;


SELECT SUBSTR("P0_SYSCNFG"."DATANAME",1,2)				      	           /*�Ĵ�����ڵ�*/
INTO :ls_sikcode
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND ( "P0_SYSCNFG"."SERIAL" = 28 ) AND ( "P0_SYSCNFG"."LINENO" = '2' )   ;
  
																								 /*�Ĵ�*/	
SELECT TO_NUMBER(SUBSTR("P0_SYSCNFG"."DATANAME",3,8))						
INTO :ll_sikdae
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND ( "P0_SYSCNFG"."SERIAL" = 28 ) AND ( "P0_SYSCNFG"."LINENO" = '2' )   ;

																					   		/*����,�߰�*/	
SELECT TO_NUMBER(SUBSTR("P0_SYSCNFG"."DATANAME",1,8))
INTO :ll_yjfree 
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND ( "P0_SYSCNFG"."SERIAL" = 28 ) AND ( "P0_SYSCNFG"."LINENO" = '3' )   ;

																						     /*�����޿�*/	
SELECT TO_NUMBER(SUBSTR("P0_SYSCNFG"."DATANAME",1,8))
INTO :ll_woljung
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND ( "P0_SYSCNFG"."SERIAL" = 28 ) AND ( "P0_SYSCNFG"."LINENO" = '4' ) ;

 
                                                                       /*����߰��������ѵ�*/	
SELECT TO_NUMBER(SUBSTR("P0_SYSCNFG"."DATANAME",1,8))                     
INTO :ll_jyhando
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND ( "P0_SYSCNFG"."SERIAL" = 28 ) AND ( "P0_SYSCNFG"."LINENO" = '0' ) ;


                                                                      /* �ٷμҵ����*/ 
SELECT To_Number(Substr(SUBSTR("P0_SYSCNFG"."DATANAME",1,50),1,8)),
       To_Number(Substr(SUBSTR("P0_SYSCNFG"."DATANAME",1,50),9,9)),
       To_Number(Substr(SUBSTR("P0_SYSCNFG"."DATANAME",1,50),18,3)),
       To_Number(Substr(SUBSTR("P0_SYSCNFG"."DATANAME",1,50),21,9))
INTO   :ll_kun1, :ll_kun1_1, :ll_kun1per, :ll_kun11
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  ( "P0_SYSCNFG"."SERIAL" = 21 ) AND
   	( "P0_SYSCNFG"."LINENO" = '1' );

SELECT To_Number(Substr(SUBSTR("P0_SYSCNFG"."DATANAME",1,50),1,8)),
       To_Number(Substr(SUBSTR("P0_SYSCNFG"."DATANAME",1,50),9,9)),
       To_Number(Substr(SUBSTR("P0_SYSCNFG"."DATANAME",1,50),18,3)),
       To_Number(Substr(SUBSTR("P0_SYSCNFG"."DATANAME",1,50),21,9))
INTO   :ll_kun2, :ll_kun2_1, :ll_kun2per, :ll_kun22
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  ( "P0_SYSCNFG"."SERIAL" = 21 ) AND
   	( "P0_SYSCNFG"."LINENO" = '2' );

SELECT To_Number(Substr(SUBSTR("P0_SYSCNFG"."DATANAME",1,50),1,8)),
       To_Number(Substr(SUBSTR("P0_SYSCNFG"."DATANAME",1,50),9,9)),
       To_Number(Substr(SUBSTR("P0_SYSCNFG"."DATANAME",1,50),18,3)),
       To_Number(Substr(SUBSTR("P0_SYSCNFG"."DATANAME",1,50),21,9))
INTO   :ll_kun3, :ll_kun3_1, :ll_kun3per, :ll_kun33
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  ( "P0_SYSCNFG"."SERIAL" = 21 ) AND
   	( "P0_SYSCNFG"."LINENO" = '3' );

SELECT To_Number(Substr(SUBSTR("P0_SYSCNFG"."DATANAME",1,50),1,8)),
       To_Number(Substr(SUBSTR("P0_SYSCNFG"."DATANAME",1,50),9,9)),
       To_Number(Substr(SUBSTR("P0_SYSCNFG"."DATANAME",1,50),18,3)),
       To_Number(Substr(SUBSTR("P0_SYSCNFG"."DATANAME",1,50),21,9))
INTO   :ll_kun4, :ll_kun4_1, :ll_kun4per, :ll_kun44
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  ( "P0_SYSCNFG"."SERIAL" = 21 ) AND
   	( "P0_SYSCNFG"."LINENO" = '4' );

SELECT To_Number(Substr(SUBSTR("P0_SYSCNFG"."DATANAME",1,50),1,8)),
       To_Number(Substr(SUBSTR("P0_SYSCNFG"."DATANAME",1,50),9,9)),
       To_Number(Substr(SUBSTR("P0_SYSCNFG"."DATANAME",1,50),18,3)),
       To_Number(Substr(SUBSTR("P0_SYSCNFG"."DATANAME",1,50),21,9))
INTO   :ll_kun5, :ll_kun5_1, :ll_kun5per, :ll_kun55
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  ( "P0_SYSCNFG"."SERIAL" = 21 ) AND
   	( "P0_SYSCNFG"."LINENO" = '5' );


SELECT TO_Number(SUBSTR("P0_SYSCNFG"."DATANAME",1,50))							/*���ʰ���*/
INTO :ll_gigong
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  ( "P0_SYSCNFG"."SERIAL" = 22 ) AND
      ( "P0_SYSCNFG"."LINENO" = '1') ;


SELECT TO_Number(SUBSTR("P0_SYSCNFG"."DATANAME",1,50))							/*����ڰ���*/
INTO :ll_baegong
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  ( "P0_SYSCNFG"."SERIAL" = 22 ) AND
   	( "P0_SYSCNFG"."LINENO" = '2') ;

SELECT TO_Number(SUBSTR("P0_SYSCNFG"."DATANAME",1,50))							/*�ξ��ڰ���*/
INTO :ll_bugong
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  ( "P0_SYSCNFG"."SERIAL" = 22 ) AND
	   ( "P0_SYSCNFG"."LINENO" = '3') ;

SELECT TO_Number(SUBSTR("P0_SYSCNFG"."DATANAME",1,50))							/*����ڰ���*/
INTO :ll_janggong
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  ( "P0_SYSCNFG"."SERIAL" = 23 ) AND
	   ( "P0_SYSCNFG"."LINENO" = '1') ;

SELECT TO_Number(SUBSTR("P0_SYSCNFG"."DATANAME",1,50))							/*��ο�����*/
INTO :ll_gyungong
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  ( "P0_SYSCNFG"."SERIAL" = 23 ) AND
	   ( "P0_SYSCNFG"."LINENO" = '2') ;

SELECT TO_Number(SUBSTR("P0_SYSCNFG"."DATANAME",1,50))							/*�γ��ڰ���*/
INTO :ll_bunygong
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  ( "P0_SYSCNFG"."SERIAL" = 23 ) AND
	   ( "P0_SYSCNFG"."LINENO" = '3') ;

SELECT TO_Number(SUBSTR("P0_SYSCNFG"."DATANAME",1,50))							/*�ڳ���������*/
INTO :ll_matgong
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  ( "P0_SYSCNFG"."SERIAL" = 23 ) AND
	   ( "P0_SYSCNFG"."LINENO" = '4') ;

SELECT TO_Number(SUBSTR("P0_SYSCNFG"."DATANAME",1,50))							/*�Ҽ�����1*/
INTO :ll_sosugong1
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  ( "P0_SYSCNFG"."SERIAL" = 23 ) AND
	   ( "P0_SYSCNFG"."LINENO" = '5') ;

SELECT TO_Number(SUBSTR("P0_SYSCNFG"."DATANAME",1,50))							/*�Ҽ�����2*/
INTO :ll_sosugong2
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  ( "P0_SYSCNFG"."SERIAL" = 23 ) AND
	   ( "P0_SYSCNFG"."LINENO" = '6') ;


SELECT TO_Number(SUBSTR("P0_SYSCNFG"."DATANAME",1,50))							/*�������*/
INTO :ll_bohum
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  ( "P0_SYSCNFG"."SERIAL" = 24 ) AND
	   ( "P0_SYSCNFG"."LINENO" = '1') ;


SELECT TO_Number(SUBSTR("P0_SYSCNFG"."DATANAME",1,50))							/*��ֺ������*/
INTO :ll_jbohum
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  ( "P0_SYSCNFG"."SERIAL" = 24 ) AND
	   ( "P0_SYSCNFG"."LINENO" = '2') ;


SELECT TO_Number(SUBSTR("P0_SYSCNFG"."DATANAME",1,50))							/*�Ƿ�������*/
INTO :ll_medper
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  ( "P0_SYSCNFG"."SERIAL" = 24 ) AND
	   ( "P0_SYSCNFG"."LINENO" = '3') ;


SELECT TO_Number(SUBSTR("P0_SYSCNFG"."DATANAME",1,50))							/*�Ƿ�����*/
INTO :ll_medhando
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  ( "P0_SYSCNFG"."SERIAL" = 24 ) AND
	   ( "P0_SYSCNFG"."LINENO" = '4') ;


SELECT TO_Number(SUBSTR("P0_SYSCNFG"."DATANAME",1,50))							/*��ġ�����������*/
INTO :ll_yuchigong
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  ( "P0_SYSCNFG"."SERIAL" = 24 ) AND
	   ( "P0_SYSCNFG"."LINENO" = '5') ;

SELECT TO_Number(SUBSTR("P0_SYSCNFG"."DATANAME",1,50))							/*���߰��������*/
INTO :ll_cjgogong
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  ( "P0_SYSCNFG"."SERIAL" = 24 ) AND
	   ( "P0_SYSCNFG"."LINENO" = '6') ;

SELECT TO_Number(SUBSTR("P0_SYSCNFG"."DATANAME",1,50))							/*���б����������*/
INTO :ll_daehakgong
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  ( "P0_SYSCNFG"."SERIAL" = 24 ) AND
	   ( "P0_SYSCNFG"."LINENO" = '7') ;


SELECT TO_Number(SUBSTR("P0_SYSCNFG"."DATANAME",1,50))							/*���ø��ð�����*/
INTO :ll_jutper
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  ( "P0_SYSCNFG"."SERIAL" = 24 ) AND
	   ( "P0_SYSCNFG"."LINENO" = '8') ;


SELECT TO_Number(SUBSTR("P0_SYSCNFG"."DATANAME",1,50))							/*���ÿ����ݻ�ȯ������*/
INTO :ll_jutchper
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  ( "P0_SYSCNFG"."SERIAL" = 24 ) AND
	   ( "P0_SYSCNFG"."LINENO" = '9') ;


SELECT TO_Number(SUBSTR("P0_SYSCNFG"."DATANAME",1,50))							/*����û��α��ѵ�*/
INTO :ll_jutchong
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  ( "P0_SYSCNFG"."SERIAL" = 24 ) AND
	   ( "P0_SYSCNFG"."LINENO" = '10') ;


SELECT TO_Number(SUBSTR("P0_SYSCNFG"."DATANAME",1,50))							/*���ð����ѵ�*/
INTO :ll_juthando
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  ( "P0_SYSCNFG"."SERIAL" = 24 ) AND
	   ( "P0_SYSCNFG"."LINENO" = '11') ;


SELECT TO_Number(SUBSTR("P0_SYSCNFG"."DATANAME",1,50))							/*�ѵ���αݰ�����*/
INTO :ll_gibuhanper
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  ( "P0_SYSCNFG"."SERIAL" = 24 ) AND
	   ( "P0_SYSCNFG"."LINENO" = '12') ;


SELECT TO_Number(SUBSTR("P0_SYSCNFG"."DATANAME",1,50))							/*ǥ�ذ����ѵ�*/
INTO :ll_standgong
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  ( "P0_SYSCNFG"."SERIAL" = 24 ) AND
	   ( "P0_SYSCNFG"."LINENO" = '13') ;


SELECT TO_Number(SUBSTR("P0_SYSCNFG"."DATANAME",1,50))							/*���ο������������*/
INTO :ll_gayunsaveper
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  ( "P0_SYSCNFG"."SERIAL" = 24 ) AND
	   ( "P0_SYSCNFG"."LINENO" = '14') ;


SELECT TO_Number(SUBSTR("P0_SYSCNFG"."DATANAME",1,50))							/*���ο����������*/
INTO :ll_gayunsave
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  ( "P0_SYSCNFG"."SERIAL" = 24 ) AND
	   ( "P0_SYSCNFG"."LINENO" = '15') ;


SELECT TO_Number(SUBSTR("P0_SYSCNFG"."DATANAME",1,50))							/*������������ѵ�*/
INTO :ll_yunsave
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  ( "P0_SYSCNFG"."SERIAL" = 24 ) AND
	   ( "P0_SYSCNFG"."LINENO" = '16') ;


SELECT TO_Number(SUBSTR("P0_SYSCNFG"."DATANAME",1,50))							/*�������հ�����*/
INTO :ll_tujaper
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  ( "P0_SYSCNFG"."SERIAL" = 24 ) AND
	   ( "P0_SYSCNFG"."LINENO" = '17') ;


SELECT TO_Number(SUBSTR("P0_SYSCNFG"."DATANAME",1,50))							/*�������հ���(�ҵ�ݾ�)�ѵ���*/
INTO :ll_tujahanper
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  ( "P0_SYSCNFG"."SERIAL" = 24 ) AND
	   ( "P0_SYSCNFG"."LINENO" = '18') ;


SELECT TO_Number(SUBSTR("P0_SYSCNFG"."DATANAME",1,50))							/*ī������ѱ޿�������*/
INTO :ll_cardpayper
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  ( "P0_SYSCNFG"."SERIAL" = 24 ) AND
	   ( "P0_SYSCNFG"."LINENO" = '19') ;


SELECT TO_Number(SUBSTR("P0_SYSCNFG"."DATANAME",1,50))							/*ī�����������*/
INTO :ll_cardper
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  ( "P0_SYSCNFG"."SERIAL" = 24 ) AND
	   ( "P0_SYSCNFG"."LINENO" = '20') ;


SELECT TO_Number(SUBSTR("P0_SYSCNFG"."DATANAME",1,50))							/*ī������ѵ�*/
INTO :ll_cardhando
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  ( "P0_SYSCNFG"."SERIAL" = 24 ) AND
	   ( "P0_SYSCNFG"."LINENO" = '21') ;


                                                                          /*����ǥ��(����������)*/    
SELECT To_Number(SUBSTR("P0_SYSCNFG"."DATANAME",1,8)),
		 To_Number(SUBSTR("P0_SYSCNFG"."DATANAME",9,9)),
		 To_Number(SUBSTR("P0_SYSCNFG"."DATANAME",18,3)),
		 To_Number(SUBSTR("P0_SYSCNFG"."DATANAME",21,8))
INTO   :ll_san1, :ll_san1_1, :ll_san1per, :ll_san11
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  ( "P0_SYSCNFG"."SERIAL" = 20 ) AND
		( "P0_SYSCNFG"."LINENO" = '1');


SELECT To_Number(SUBSTR("P0_SYSCNFG"."DATANAME",1,8)),
		 To_Number(SUBSTR("P0_SYSCNFG"."DATANAME",9,9)),
		 To_Number(SUBSTR("P0_SYSCNFG"."DATANAME",18,3)),
		 To_Number(SUBSTR("P0_SYSCNFG"."DATANAME",21,8))
INTO   :ll_san2, :ll_san2_1, :ll_san2per, :ll_san22
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  ( "P0_SYSCNFG"."SERIAL" = 20 ) AND
		( "P0_SYSCNFG"."LINENO" = '2');


SELECT To_Number(SUBSTR("P0_SYSCNFG"."DATANAME",1,8)),
		 To_Number(SUBSTR("P0_SYSCNFG"."DATANAME",9,9)),
		 To_Number(SUBSTR("P0_SYSCNFG"."DATANAME",18,3)),
		 To_Number(SUBSTR("P0_SYSCNFG"."DATANAME",21,8))
INTO   :ll_san3, :ll_san3_1, :ll_san3per, :ll_san33
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  ( "P0_SYSCNFG"."SERIAL" = 20 ) AND
		( "P0_SYSCNFG"."LINENO" = '3');


SELECT To_Number(SUBSTR("P0_SYSCNFG"."DATANAME",1,8)),
		 To_Number(SUBSTR("P0_SYSCNFG"."DATANAME",9,9)),
		 To_Number(SUBSTR("P0_SYSCNFG"."DATANAME",18,3)),
		 To_Number(SUBSTR("P0_SYSCNFG"."DATANAME",21,8))
INTO   :ll_san4, :ll_san4_1, :ll_san4per, :ll_san44
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  ( "P0_SYSCNFG"."SERIAL" = 20 ) AND
		( "P0_SYSCNFG"."LINENO" = '4');


SELECT To_Number(SUBSTR("P0_SYSCNFG"."DATANAME",1,7))				/*���װ��� ���رݾ�*/
INTO :ll_sangi
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  ( "P0_SYSCNFG"."SERIAL" = 26 ) AND
		( "P0_SYSCNFG"."LINENO" = '0');


SELECT To_Number(SUBSTR("P0_SYSCNFG"."DATANAME",1,3))				/*���װ��� ���رݾ� ���� ����*/
INTO :ll_sanehaper
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  ( "P0_SYSCNFG"."SERIAL" = 26 ) AND
		( "P0_SYSCNFG"."LINENO" = '1');


SELECT To_Number(SUBSTR("P0_SYSCNFG"."DATANAME",1,3))				/*���װ��� ���رݾ� �ʰ� ����*/
INTO :ll_sanchoper
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  ( "P0_SYSCNFG"."SERIAL" = 26 ) AND
		( "P0_SYSCNFG"."LINENO" = '2');


SELECT To_Number(SUBSTR("P0_SYSCNFG"."DATANAME",1,7))				/*���װ����ѵ��ݾ�*/
INTO :ll_sankunhan
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  ( "P0_SYSCNFG"."SERIAL" = 26 ) AND
		( "P0_SYSCNFG"."LINENO" = '3');


SELECT To_Number(SUBSTR("P0_SYSCNFG"."DATANAME",1,3))				/*�����ڱݼ��װ�����*/
INTO :ll_jutseackper
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  ( "P0_SYSCNFG"."SERIAL" = 26 ) AND
		( "P0_SYSCNFG"."LINENO" = '4');


SELECT To_Number(SUBSTR("P0_SYSCNFG"."DATANAME",1,3))				/*������Ǵ��ذ�����*/
INTO :ll_jangikum
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  ( "P0_SYSCNFG"."SERIAL" = 26 ) AND
		( "P0_SYSCNFG"."LINENO" = '5');


SELECT To_Number(SUBSTR("P0_SYSCNFG"."DATANAME",1,3))				/*����������������*/
INTO :ll_jangiago
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  ( "P0_SYSCNFG"."SERIAL" = 26 ) AND
		( "P0_SYSCNFG"."LINENO" = '6');



SELECT To_Number(Substr(SUBSTR("P0_SYSCNFG"."DATANAME",1,50),1,3))   /*�����ҵ������*/
INTO   :ll_tjper
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  ( "P0_SYSCNFG"."SERIAL" = 40 ) AND
   	( "P0_SYSCNFG"."LINENO" = '1' );

SELECT To_Number(Substr(SUBSTR("P0_SYSCNFG"."DATANAME",1,50),1,2)),   /*�����ҵ�ټӳ���� ����*/
       To_Number(Substr(SUBSTR("P0_SYSCNFG"."DATANAME",1,50),3,2)),
       To_Number(Substr(SUBSTR("P0_SYSCNFG"."DATANAME",1,50),5,8)),
       To_Number(Substr(SUBSTR("P0_SYSCNFG"."DATANAME",1,50),13,7))
INTO   :ll_tjyear1, :ll_tjyear1_1, :ll_tjyear1amt, :ll_tjyear11
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  ( "P0_SYSCNFG"."SERIAL" = 41 ) AND
   	( "P0_SYSCNFG"."LINENO" = '1' );
		
		
SELECT To_Number(Substr(SUBSTR("P0_SYSCNFG"."DATANAME",1,50),1,2)),
       To_Number(Substr(SUBSTR("P0_SYSCNFG"."DATANAME",1,50),3,2)),
       To_Number(Substr(SUBSTR("P0_SYSCNFG"."DATANAME",1,50),5,8)),
       To_Number(Substr(SUBSTR("P0_SYSCNFG"."DATANAME",1,50),13,7))
INTO   :ll_tjyear2, :ll_tjyear2_1, :ll_tjyear2amt, :ll_tjyear22
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  ( "P0_SYSCNFG"."SERIAL" = 41 ) AND
   	( "P0_SYSCNFG"."LINENO" = '2' );
		

SELECT To_Number(Substr(SUBSTR("P0_SYSCNFG"."DATANAME",1,50),1,2)),
       To_Number(Substr(SUBSTR("P0_SYSCNFG"."DATANAME",1,50),3,2)),
       To_Number(Substr(SUBSTR("P0_SYSCNFG"."DATANAME",1,50),5,8)),
       To_Number(Substr(SUBSTR("P0_SYSCNFG"."DATANAME",1,50),13,7))
INTO   :ll_tjyear3, :ll_tjyear3_1, :ll_tjyear3amt, :ll_tjyear33
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  ( "P0_SYSCNFG"."SERIAL" = 41 ) AND
   	( "P0_SYSCNFG"."LINENO" = '3' );
		
		
SELECT To_Number(Substr(SUBSTR("P0_SYSCNFG"."DATANAME",1,50),1,2)),
       To_Number(Substr(SUBSTR("P0_SYSCNFG"."DATANAME",1,50),3,2)),
       To_Number(Substr(SUBSTR("P0_SYSCNFG"."DATANAME",1,50),5,8)),
       To_Number(Substr(SUBSTR("P0_SYSCNFG"."DATANAME",1,50),13,7))
INTO   :ll_tjyear4, :ll_tjyear4_1, :ll_tjyear4amt, :ll_tjyear44
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  ( "P0_SYSCNFG"."SERIAL" = 41 ) AND
   	( "P0_SYSCNFG"."LINENO" = '4' );		



SELECT To_Number(Substr(SUBSTR("P0_SYSCNFG"."DATANAME",1,50),1,3))        /*�����ҵ漼�װ�����*/     
INTO   :ll_tjseackgong
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  ( "P0_SYSCNFG"."SERIAL" = 42 ) AND
   	( "P0_SYSCNFG"."LINENO" = '1' );


SELECT To_Number(Substr(SUBSTR("P0_SYSCNFG"."DATANAME",1,50),1,6))       /*�����ҵ�����ѵ���*/
INTO   :ll_tjseackhan
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  ( "P0_SYSCNFG"."SERIAL" = 42 ) AND
   	( "P0_SYSCNFG"."LINENO" = '2' );


SELECT To_Number(Substr(SUBSTR("P0_SYSCNFG"."DATANAME",1,50),1,6))       /*��뺸�������*/
INTO   :ld_goyungper 
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  ( "P0_SYSCNFG"."SERIAL" = 18 ) AND
   	( "P0_SYSCNFG"."LINENO" = '1' );
		
		
SELECT To_Number(Substr(SUBSTR("P0_SYSCNFG"."DATANAME",1,50),1,6))       /*����ȸ�������*/
INTO   :ld_nojoper
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  ( "P0_SYSCNFG"."SERIAL" = 17 ) AND
   	( "P0_SYSCNFG"."LINENO" = '1' );
		
		
SELECT To_Number(Substr(SUBSTR("P0_SYSCNFG"."DATANAME",1,50),1,6))       /*���ȸ�������*/
INTO   :ll_sawoo
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  ( "P0_SYSCNFG"."SERIAL" = 16 ) AND
   	( "P0_SYSCNFG"."LINENO" = '1' );	
		
		
SELECT rtrim("P0_SYSCNFG"."DATANAME")                             /*������������*/
INTO   :ls_bdate
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  ( "P0_SYSCNFG"."SERIAL" = 4) AND
   	( "P0_SYSCNFG"."LINENO" = '1' );		
		
		
SELECT rtrim("P0_SYSCNFG"."DATANAME")                              /*�޿�������*/
INTO   :ls_pdate
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  ( "P0_SYSCNFG"."SERIAL" = 10) AND
   	( "P0_SYSCNFG"."LINENO" = '1' );		
		
		
SELECT rtrim("P0_SYSCNFG"."DATANAME")                               /*�������ڵ�*/
INTO   :ls_semuse
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  ( "P0_SYSCNFG"."SERIAL" = 70) AND
   	( "P0_SYSCNFG"."LINENO" = '1' );				
		
		
SELECT rtrim("P0_SYSCNFG"."DATANAME")                          /*������ü��ȣ*/
INTO   :ls_ptongno
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  ( "P0_SYSCNFG"."SERIAL" = 55) AND
   	( "P0_SYSCNFG"."LINENO" = '1' );		
		
SELECT rtrim("P0_SYSCNFG"."DATANAME")                          /*�������ڱٷ��ϼ����Կ���*/
INTO   :ls_tjdaygubn
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  ( "P0_SYSCNFG"."SERIAL" = 43) AND
   	( "P0_SYSCNFG"."LINENO" = '1' );		
		

SELECT rtrim("P0_SYSCNFG"."DATANAME")                          /*�ݾ�������*/
INTO   :amtgbn
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  ( "P0_SYSCNFG"."SERIAL" = 60) AND
   	( "P0_SYSCNFG"."LINENO" = '1' );		
		
		
		
dw_list.Setitem(1,"wonjun", ll_wonjun)
dw_list.Setitem(1,"woncode", ls_woncode)
dw_list.setitem(1,"sikdae",  ll_sikdae)
dw_list.setitem(1,"sikcode", ls_sikcode )
dw_list.setitem(1,"yjfree" ,ll_yjfree)
dw_list.setitem(1,"woljung" ,ll_woljung)
dw_list.setitem(1,"kun1" ,ll_kun1 )
dw_list.setitem(1,"kun1_1", ll_kun1_1)
dw_list.setitem(1,"kun11", ll_kun11 )
dw_list.setitem(1,"kun1per", ll_kun1per )
dw_list.setitem(1,"kun2", ll_kun2)
dw_list.setitem(1,"kun2_1", ll_kun2_1 )
dw_list.setitem(1,"kun22", ll_kun22 )
dw_list.setitem(1,"kun2per", ll_kun2per )
dw_list.setitem(1,"kun3", ll_kun3 )
dw_list.setitem(1,"kun3_1", ll_kun3_1 )
dw_list.setitem(1,"kun33", ll_kun33 )
dw_list.setitem(1,"kun3per", ll_kun3per)
dw_list.setitem(1,"kun4", ll_kun4 )
dw_list.setitem(1,"kun4_1", ll_kun4_1 )
dw_list.setitem(1,"kun44",ll_kun44)
dw_list.setitem(1,"kun4per", ll_kun4per)
dw_list.setitem(1,"kun5", ll_kun5 )
dw_list.setitem(1,"kun5_1", ll_kun5_1) 
dw_list.setitem(1,"kun55", ll_kun55 )
dw_list.setitem(1,"kun5per",ll_kun5per ) 
dw_list.setitem(1,"gigong" ,ll_gigong )
dw_list.setitem(1,"baegong" ,ll_baegong)
dw_list.setitem(1,"bugong" ,ll_bugong)
dw_list.setitem(1,"janggong", ll_janggong )
dw_list.setitem(1,"gyungong" ,ll_gyungong)
dw_list.setitem(1,"bunygong" ,ll_bunygong) 
dw_list.setitem(1,"matgong" ,ll_matgong )
dw_list.setitem(1,"sosugong1", ll_sosugong1 )
dw_list.setitem(1,"sosugong2" ,ll_sosugong2 )
dw_list.setitem(1,"yuchigong" ,ll_yuchigong)
dw_list.setitem(1,"cjgogong" ,ll_cjgogong )
dw_list.setitem(1,"daehakgong", ll_daehakgong )
dw_list.setitem(1,"medper" ,ll_medper )
dw_list.setitem(1,"medhando", ll_medhando)
dw_list.setitem(1,"bohum" ,ll_bohum)
dw_list.setitem(1,"jbohum" ,ll_jbohum)
dw_list.setitem(1,"jutper" ,ll_jutper)
dw_list.setitem(1,"jutchper", ll_jutchper)
dw_list.setitem(1,"jutchong" ,ll_jutchong)
dw_list.setitem(1,"juthando" ,ll_juthando)
dw_list.setitem(1,"gibuhanper", ll_gibuhanper)
dw_list.setitem(1,"standgong" , ll_standgong)
dw_list.setitem(1,"gayunsave" , ll_gayunsave)
dw_list.setitem(1,"gayunsaveper", ll_gayunsaveper)
dw_list.setitem(1,"yunsave" , ll_yunsave)
dw_list.setitem(1,"tujaper" , ll_tujaper)
dw_list.setitem(1,"tujahanper", ll_tujahanper)
dw_list.setitem(1,"cardpayper" , ll_cardpayper)
dw_list.setitem(1,"cardper" , ll_cardper)
dw_list.setitem(1,"cardhando", ll_cardhando)
dw_list.setitem(1,"san1" , ll_san1)
dw_list.setitem(1,"san1_1",  ll_san1_1)
dw_list.setitem(1,"san11" ,ll_san11)
dw_list.setitem(1,"san1per", ll_san1per)
dw_list.setitem(1,"san2" ,ll_san2 )
dw_list.setitem(1,"san2_1", ll_san2_1) 
dw_list.setitem(1,"san22" ,ll_san22)
dw_list.setitem(1,"san2per", ll_san2per)
dw_list.setitem(1,"san3" ,ll_san3)
dw_list.setitem(1,"san3_1", ll_san3_1 )
dw_list.setitem(1,"san33" ,ll_san33)
dw_list.setitem(1,"san3per", ll_san3per)
dw_list.setitem(1,"san4" ,ll_san4)
dw_list.setitem(1,"san4_1", ll_san4_1)
dw_list.setitem(1,"san44" ,ll_san44)
dw_list.setitem(1,"san4per", ll_san4per)
dw_list.setitem(1,"sangi" ,ll_sangi )
dw_list.setitem(1,"sanehaper", ll_sanehaper)
dw_list.setitem(1,"sanchoper", ll_sanchoper )
dw_list.setitem(1,"sankunhan" ,ll_sankunhan )
dw_list.setitem(1,"jutseackper", ll_jutseackper )
dw_list.setitem(1,"jangiago" ,ll_jangiago)
dw_list.setitem(1,"jangikum" ,ll_jangikum )
dw_list.setitem(1,"tjper" ,ll_tjper)
dw_list.setitem(1,"tjyear1", ll_tjyear1 )
dw_list.setitem(1,"tjyear1_1", ll_tjyear1_1) 
dw_list.setitem(1,"tjyear11" ,ll_tjyear11 )
dw_list.setitem(1,"tjyear1amt", ll_tjyear1amt )
dw_list.setitem(1,"tjyear2" ,ll_tjyear2 )
dw_list.setitem(1,"tjyear2_1", ll_tjyear2_1) 
dw_list.setitem(1,"tjyear22" ,ll_tjyear22 )
dw_list.setitem(1,"tjyear2amt", ll_tjyear2amt )
dw_list.setitem(1,"tjyear3" ,ll_tjyear3 )
dw_list.setitem(1,"tjyear3_1", ll_tjyear3_1) 
dw_list.setitem(1,"tjyear33" ,ll_tjyear33 )
dw_list.setitem(1,"tjyear3amt" ,ll_tjyear3amt)
dw_list.setitem(1,"tjyear4" ,ll_tjyear4)
dw_list.setitem(1,"tjyear4_1", ll_tjyear4_1)
dw_list.setitem(1,"tjyear44" ,ll_tjyear44 )
dw_list.setitem(1,"tjyear4amt", ll_tjyear4amt)
dw_list.setitem(1,"tjseackgong", ll_tjseackgong)
dw_list.setitem(1,"tjseackhan" ,ll_tjseackhan )
dw_list.setitem(1,"bdate",string(ls_bdate,'@@@@.@@.@@'))
dw_list.setitem(1,"pdate",ls_pdate)
dw_list.setitem(1,"semuse", ls_semuse)
dw_list.setitem(1,"ptongno",ls_ptongno)
dw_list.setitem(1,"goyungper",ld_goyungper)
dw_list.setitem(1,"nojoper",ld_nojoper)
dw_list.setitem(1,"sawoo",ll_sawoo)
dw_list.setitem(1,'tjdaygubn',ls_tjdaygubn)
dw_list.setitem(1,'amtflag',amtgbn)

end event

type p_mod from w_inherite_standard`p_mod within w_piz2001
integer x = 4242
end type

event p_mod::clicked;call super::clicked;if f_msg_update() = -1 then
	return 
else 
	Setpointer(HourGlass!)
end if
	


string ls_woncode, ls_sikcode,ls_tjdaygubn
string ls_bdate, ls_pdate, ls_semuse, ls_ptongno
long ll_wonjun, ll_sikdae, ll_yjfree, ll_woljung, ll_jyhando
long ll_kun1, ll_kun1_1, ll_kun1per, ll_kun11, ll_kun2, ll_kun2_1, ll_kun2per, ll_kun22
long ll_kun3, ll_kun3_1, ll_kun3per, ll_kun33, ll_kun4, ll_kun4_1, ll_kun4per, ll_kun44
long ll_kun5, ll_kun5_1, ll_kun5per, ll_kun55
long ll_gigong,ll_baegong,ll_bugong,ll_janggong,ll_gyungong,ll_bunygong,ll_matgong,ll_sosugong1,ll_sosugong2
long ll_bohum,ll_jbohum,ll_medper, ll_medhando,ll_yuchigong,ll_cjgogong,ll_daehakgong
long ll_jutper,ll_juthando,ll_gibuhanper,ll_standgong,ll_gayunsaveper,ll_gayunsave,ll_yunsave
long ll_tujaper,ll_tujahanper,ll_cardpayper,ll_cardper,ll_cardhando
long ll_jutchper, ll_jutchong
long ll_san1, ll_san1_1, ll_san1per, ll_san11, ll_san2, ll_san2_1, ll_san2per, ll_san22
long ll_san3, ll_san3_1, ll_san3per, ll_san33, ll_san4, ll_san4_1, ll_san4per, ll_san44
long ll_sangi,ll_sanehaper,ll_sanchoper,ll_sankunhan,ll_jutseackper,ll_jangikum,ll_jangiago
long ll_tjper
long ll_tjyear1, ll_tjyear1_1, ll_tjyear1amt, ll_tjyear11
long ll_tjyear2, ll_tjyear2_1, ll_tjyear2amt, ll_tjyear22
long ll_tjyear3, ll_tjyear3_1, ll_tjyear3amt, ll_tjyear33
long ll_tjyear4, ll_tjyear4_1, ll_tjyear4amt, ll_tjyear44
long ll_tjseackhan, ll_tjseackgong
long ll_sawoo
double ld_goyungper, ld_nojoper
string amtgbn

if dw_list.Accepttext() = -1 then return

ll_wonjun = dw_list.GetitemNumber(1,"wonjun" )
ls_woncode = dw_list.GetitemString(1,"woncode" )
ll_sikdae = dw_list.GetitemNumber(1,"sikdae" )
ls_sikcode = dw_list.GetitemString(1,"sikcode"  )
ll_yjfree = dw_list.GetitemNumber(1,"yjfree" )
ll_woljung = dw_list.GetitemNumber(1,"woljung" )
ll_kun1 = dw_list.GetitemNumber(1,"kun1" )
ll_kun1_1 = dw_list.GetitemNumber(1,"kun1_1")
ll_kun11 = dw_list.GetitemNumber(1,"kun11"  )
ll_kun1per = dw_list.GetitemNumber(1,"kun1per" )
ll_kun2= dw_list.GetitemNumber(1,"kun2")
ll_kun2_1= dw_list.GetitemNumber(1,"kun2_1" )
ll_kun22 = dw_list.GetitemNumber(1,"kun22" )
ll_kun2per = dw_list.GetitemNumber(1,"kun2per" )
ll_kun3 = dw_list.GetitemNumber(1,"kun3" )
ll_kun3_1 = dw_list.GetitemNumber(1,"kun3_1" )
ll_kun33 = dw_list.GetitemNumber(1,"kun33" )
ll_kun3per = dw_list.GetitemNumber(1,"kun3per")
ll_kun4 = dw_list.GetitemNumber(1,"kun4" )
ll_kun4_1 = dw_list.GetitemNumber(1,"kun4_1" )
ll_kun44 = dw_list.GetitemNumber(1,"kun44")
ll_kun4per = dw_list.GetitemNumber(1,"kun4per")
ll_kun5 = dw_list.GetitemNumber(1,"kun5" )
ll_kun5_1 = dw_list.GetitemNumber(1,"kun5_1") 
ll_kun55 = dw_list.GetitemNumber(1,"kun55" )
ll_kun5per = dw_list.GetitemNumber(1,"kun5per" ) 
ll_gigong = dw_list.GetitemNumber(1,"gigong"  )
ll_baegong = dw_list.GetitemNumber(1,"baegong" )
ll_bugong = dw_list.GetitemNumber(1,"bugong" )
ll_janggong = dw_list.GetitemNumber(1,"janggong" )
ll_gyungong = dw_list.GetitemNumber(1,"gyungong")
ll_bunygong = dw_list.GetitemNumber(1,"bunygong" ) 
ll_matgong = dw_list.GetitemNumber(1,"matgong" )
ll_sosugong1 = dw_list.GetitemNumber(1,"sosugong1" )
ll_sosugong2 = dw_list.GetitemNumber(1,"sosugong2"  )
ll_yuchigong = dw_list.GetitemNumber(1,"yuchigong" )
ll_cjgogong = dw_list.GetitemNumber(1,"cjgogong"  )
ll_daehakgong = dw_list.GetitemNumber(1,"daehakgong" )
ll_medper = dw_list.GetitemNumber(1,"medper"  )
ll_medhando = dw_list.GetitemNumber(1,"medhando")
ll_bohum = dw_list.GetitemNumber(1,"bohum" )
ll_jbohum = dw_list.GetitemNumber(1,"jbohum" )
ll_jutper = dw_list.GetitemNumber(1,"jutper" )
ll_jutchper = dw_list.GetitemNumber(1,"jutchper")
ll_jutchong = dw_list.GetitemNumber(1,"jutchong" )
ll_juthando = dw_list.GetitemNumber(1,"juthando" )
ll_gibuhanper = dw_list.GetitemNumber(1,"gibuhanper")
ll_standgong = dw_list.GetitemNumber(1,"standgong" )
ll_gayunsave = dw_list.GetitemNumber(1,"gayunsave" )
ll_gayunsaveper = dw_list.GetitemNumber(1,"gayunsaveper")
ll_yunsave = dw_list.GetitemNumber(1,"yunsave" )
ll_tujaper = dw_list.GetitemNumber(1,"tujaper" )
ll_tujahanper = dw_list.GetitemNumber(1,"tujahanper")
ll_cardpayper = dw_list.GetitemNumber(1,"cardpayper" )
ll_cardper = dw_list.GetitemNumber(1,"cardper" )
ll_cardhando = dw_list.GetitemNumber(1,"cardhando")
ll_san1 = dw_list.GetitemNumber(1,"san1" )
ll_san1_1 = dw_list.GetitemNumber(1,"san1_1")
ll_san11 = dw_list.GetitemNumber(1,"san11" )
ll_san1per = dw_list.GetitemNumber(1,"san1per" )
ll_san2 = dw_list.GetitemNumber(1,"san2" )
ll_san2_1 = dw_list.GetitemNumber(1,"san2_1" ) 
ll_san22 = dw_list.GetitemNumber(1,"san22" )
ll_san2per = dw_list.GetitemNumber(1,"san2per")
ll_san3 = dw_list.GetitemNumber(1,"san3" )
ll_san3_1 = dw_list.GetitemNumber(1,"san3_1" )
ll_san33 = dw_list.GetitemNumber(1,"san33" )
ll_san3per = dw_list.GetitemNumber(1,"san3per" )
ll_san4 = dw_list.GetitemNumber(1,"san4" )
ll_san4_1 = dw_list.GetitemNumber(1,"san4_1")
ll_san44 = dw_list.GetitemNumber(1,"san44")
ll_san4per = dw_list.GetitemNumber(1,"san4per")
ll_sangi = dw_list.GetitemNumber(1,"sangi"  )
ll_sanehaper = dw_list.GetitemNumber(1,"sanehaper")
ll_sanchoper = dw_list.GetitemNumber(1,"sanchoper" )
ll_sankunhan = dw_list.GetitemNumber(1,"sankunhan"  )
ll_jutseackper = dw_list.GetitemNumber(1,"jutseackper")
ll_jangiago = dw_list.GetitemNumber(1,"jangiago" )
ll_jangikum = dw_list.GetitemNumber(1,"jangikum"  )
ll_tjper = dw_list.GetitemNumber(1,"tjper" )
ll_tjyear1 = dw_list.GetitemNumber(1,"tjyear1" )
ll_tjyear1_1 = dw_list.GetitemNumber(1,"tjyear1_1") 
ll_tjyear11 = dw_list.GetitemNumber(1,"tjyear11"  )
ll_tjyear1amt = dw_list.GetitemNumber(1,"tjyear1amt" )
ll_tjyear2 = dw_list.GetitemNumber(1,"tjyear2" )
ll_tjyear2_1 = dw_list.GetitemNumber(1,"tjyear2_1") 
ll_tjyear22 = dw_list.GetitemNumber(1,"tjyear22" )
ll_tjyear2amt = dw_list.GetitemNumber(1,"tjyear2amt")
ll_tjyear3 = dw_list.GetitemNumber(1,"tjyear3" )
ll_tjyear3_1 = dw_list.GetitemNumber(1,"tjyear3_1") 
ll_tjyear33 = dw_list.GetitemNumber(1,"tjyear33" )
ll_tjyear3amt = dw_list.GetitemNumber(1,"tjyear3amt" )
ll_tjyear4 = dw_list.GetitemNumber(1,"tjyear4" )
ll_tjyear4_1 = dw_list.GetitemNumber(1,"tjyear4_1")
ll_tjyear44 = dw_list.GetitemNumber(1,"tjyear44" )
ll_tjyear4amt = dw_list.GetitemNumber(1,"tjyear4amt")
ll_tjseackgong = dw_list.GetitemNumber(1,"tjseackgong")
ll_tjseackhan = dw_list.GetitemNumber(1,"tjseackhan" )
ls_bdate = dw_list.GetitemString(1,"bdate")
ls_bdate = left(ls_bdate,4)+mid(ls_bdate,6,2)+right(ls_bdate,2)
ls_pdate = dw_list.GetitemString(1,"pdate")
ls_semuse = dw_list.GetitemString(1,"semuse")
ls_ptongno = dw_list.GetitemString(1,"ptongno")
ld_goyungper = dw_list.GetitemNumber(1,"goyungper")
ld_nojoper = dw_list.GetitemNumber(1,"nojoper")
ll_sawoo = dw_list.GetitemNumber(1,"sawoo")
ls_tjdaygubn = dw_list.GetitemString(1,'tjdaygubn')
amtgbn = dw_list.GetitemString(1,'amtflag')



UPDATE P0_SYSCNFG                                              /*��������*/
SET DATANAME = :ls_woncode||to_char(:ll_wonjun)
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND ( "P0_SYSCNFG"."SERIAL" = 28 ) AND ( "P0_SYSCNFG"."LINENO" = '1' )   ;

UPDATE P0_SYSCNFG                                              /*�Ĵ�*/	
SET DATANAME = :ls_sikcode||to_char(:ll_sikdae)
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND ( "P0_SYSCNFG"."SERIAL" = 28 ) AND ( "P0_SYSCNFG"."LINENO" = '2' )   ;


UPDATE P0_SYSCNFG                                             /*����,�߰�*/	
SET DATANAME = to_char(:ll_yjfree)
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND ( "P0_SYSCNFG"."SERIAL" = 28 ) AND ( "P0_SYSCNFG"."LINENO" = '3' )   ;


UPDATE P0_SYSCNFG                                             /*�����޿�*/		
SET DATANAME = to_char(:ll_woljung)
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND ( "P0_SYSCNFG"."SERIAL" = 28 ) AND ( "P0_SYSCNFG"."LINENO" = '4' )   ;


UPDATE P0_SYSCNFG                                             /*����߰��������ѵ�*/		
SET DATANAME = to_char(:ll_jyhando)
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND ( "P0_SYSCNFG"."SERIAL" = 28 ) AND ( "P0_SYSCNFG"."LINENO" = '0' )   ;


string ls_kun1, ls_kun2, ls_kun3, ls_kun4, ls_kun5
ls_kun1 = string(ll_kun1,'00000000')
ls_kun1 = ls_kun1 + string(ll_kun1_1,'000000000')
ls_kun1 = ls_kun1 + string(ll_kun1per,'000')
ls_kun1 = ls_kun1 + string(ll_kun11,'000000000')

UPDATE P0_SYSCNFG                                              /* �ٷμҵ����*/ 		
SET DATANAME = :ls_kun1
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND ( "P0_SYSCNFG"."SERIAL" = 21 ) AND ( "P0_SYSCNFG"."LINENO" = '1' )   ;

ls_kun2 = string(ll_kun2,'00000000')
ls_kun2 = ls_kun2 + string(ll_kun2_1,'000000000')
ls_kun2 = ls_kun2 + string(ll_kun2per,'000')
ls_kun2 = ls_kun2 + string(ll_kun22,'000000000')

UPDATE P0_SYSCNFG                                              /* �ٷμҵ����*/ 		
SET DATANAME = :ls_kun2
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND ( "P0_SYSCNFG"."SERIAL" = 21 ) AND ( "P0_SYSCNFG"."LINENO" = '2' )   ;


ls_kun3 = string(ll_kun3,'00000000')
ls_kun3 = ls_kun3 + string(ll_kun3_1,'000000000')
ls_kun3 = ls_kun3 + string(ll_kun3per,'000')
ls_kun3 = ls_kun3 + string(ll_kun33,'000000000')

UPDATE P0_SYSCNFG                                              /* �ٷμҵ����*/ 		
SET DATANAME = :ls_kun3
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND ( "P0_SYSCNFG"."SERIAL" = 21 ) AND ( "P0_SYSCNFG"."LINENO" = '3' )   ;


ls_kun4 = string(ll_kun4,'00000000')
ls_kun4 = ls_kun4 + string(ll_kun4_1,'000000000')
ls_kun4 = ls_kun4 + string(ll_kun4per,'000')
ls_kun4 = ls_kun4 + string(ll_kun44,'000000000')

UPDATE P0_SYSCNFG                                              /* �ٷμҵ����*/ 		
SET DATANAME = :ls_kun4
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND ( "P0_SYSCNFG"."SERIAL" = 21 ) AND ( "P0_SYSCNFG"."LINENO" = '4' )   ;


ls_kun5 = string(ll_kun5,'00000000')
ls_kun5 = ls_kun5 + string(ll_kun5_1,'000000000')
ls_kun5 = ls_kun5 + string(ll_kun5per,'000')
ls_kun5 = ls_kun5 + string(ll_kun55,'000000000')

UPDATE P0_SYSCNFG                                              /* �ٷμҵ����*/ 		
SET DATANAME = :ls_kun5
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND ( "P0_SYSCNFG"."SERIAL" = 21 ) AND ( "P0_SYSCNFG"."LINENO" = '5' )   ;


UPDATE P0_SYSCNFG                                              /*���ʰ���*/		
SET DATANAME = to_char(:ll_gigong)
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND ( "P0_SYSCNFG"."SERIAL" = 22 ) AND 
      ( "P0_SYSCNFG"."LINENO" = '1' )   ;

UPDATE P0_SYSCNFG                                              /*����ڰ���*/	
SET DATANAME = to_char(:ll_gigong)
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND ( "P0_SYSCNFG"."SERIAL" = 22 ) AND 
      ( "P0_SYSCNFG"."LINENO" = '2' )   ;

UPDATE P0_SYSCNFG                                              /*�ξ��ڰ���*/
SET DATANAME = to_char(:ll_bugong)
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND ( "P0_SYSCNFG"."SERIAL" = 22 ) AND 
      ( "P0_SYSCNFG"."LINENO" = '3' )   ;
		
UPDATE P0_SYSCNFG                                              /*����ڰ���*/
SET DATANAME = to_char(:ll_janggong)
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND ( "P0_SYSCNFG"."SERIAL" = 23 ) AND 
      ( "P0_SYSCNFG"."LINENO" = '1' )   ;


UPDATE P0_SYSCNFG                                              /*��ο�����*/
SET DATANAME = to_char(:ll_gyungong)
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND ( "P0_SYSCNFG"."SERIAL" = 23 ) AND 
      ( "P0_SYSCNFG"."LINENO" = '2' )   ;


UPDATE P0_SYSCNFG                                             /*�γ��ڰ���*/
SET DATANAME = to_char(:ll_bunygong)
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND ( "P0_SYSCNFG"."SERIAL" = 23 ) AND 
      ( "P0_SYSCNFG"."LINENO" = '3' )   ;


UPDATE P0_SYSCNFG                                              /*�ڳ���������*/
SET DATANAME = to_char(:ll_matgong)
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND ( "P0_SYSCNFG"."SERIAL" = 23 ) AND 
      ( "P0_SYSCNFG"."LINENO" = '4' )   ;


UPDATE P0_SYSCNFG                                              /*�Ҽ�����1*/
SET DATANAME = to_char(:ll_sosugong1)
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND ( "P0_SYSCNFG"."SERIAL" = 23 ) AND 
      ( "P0_SYSCNFG"."LINENO" = '5' )   ;

UPDATE P0_SYSCNFG                                              /*�Ҽ�����2*/
SET DATANAME = to_char(:ll_sosugong2)
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND ( "P0_SYSCNFG"."SERIAL" = 23 ) AND 
      ( "P0_SYSCNFG"."LINENO" = '6' )   ;


UPDATE P0_SYSCNFG                                              /*�������*/
SET DATANAME = to_char(:ll_bohum)
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND ( "P0_SYSCNFG"."SERIAL" = 24 ) AND 
      ( "P0_SYSCNFG"."LINENO" = '1' )   ;

UPDATE P0_SYSCNFG                                              /*��ֺ������*/
SET DATANAME = to_char(:ll_jbohum)
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND ( "P0_SYSCNFG"."SERIAL" = 24 ) AND 
      ( "P0_SYSCNFG"."LINENO" = '2' )   ;
		

UPDATE P0_SYSCNFG                                              /*�Ƿ�������*/
SET DATANAME = to_char(:ll_medper)
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND ( "P0_SYSCNFG"."SERIAL" = 24 ) AND 
      ( "P0_SYSCNFG"."LINENO" = '3' )   ;		
		
		
UPDATE P0_SYSCNFG                                              /*�Ƿ�����*/
SET DATANAME = to_char(:ll_medhando)
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND ( "P0_SYSCNFG"."SERIAL" = 24 ) AND 
      ( "P0_SYSCNFG"."LINENO" = '4' )   ;				
		
		
UPDATE P0_SYSCNFG                                              /*��ġ�����������*/
SET DATANAME = to_char(:ll_yuchigong)
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND ( "P0_SYSCNFG"."SERIAL" = 24 ) AND 
      ( "P0_SYSCNFG"."LINENO" = '5' )   ;				


UPDATE P0_SYSCNFG                                              /*���߰��������*/
SET DATANAME = to_char(:ll_cjgogong)
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND ( "P0_SYSCNFG"."SERIAL" = 24 ) AND 
      ( "P0_SYSCNFG"."LINENO" = '6' )   ;				


UPDATE P0_SYSCNFG                                              /*���б����������*/
SET DATANAME = to_char(:ll_daehakgong)
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND ( "P0_SYSCNFG"."SERIAL" = 24 ) AND 
      ( "P0_SYSCNFG"."LINENO" = '7' )   ;		
		

UPDATE P0_SYSCNFG                                              /*���ø��ð�����*/
SET DATANAME = to_char(:ll_jutper)
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND ( "P0_SYSCNFG"."SERIAL" = 24 ) AND 
      ( "P0_SYSCNFG"."LINENO" = '8' )   ;	


UPDATE P0_SYSCNFG                                              /*���ÿ����ݻ�ȯ������*/
SET DATANAME = to_char(:ll_jutchper)
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND ( "P0_SYSCNFG"."SERIAL" = 24 ) AND 
      ( "P0_SYSCNFG"."LINENO" = '9' )   ;	

UPDATE P0_SYSCNFG                                              /*����û��α��ѵ�*/
SET DATANAME = to_char(:ll_jutchong)
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND ( "P0_SYSCNFG"."SERIAL" = 24 ) AND 
      ( "P0_SYSCNFG"."LINENO" = '10' )   ;	

UPDATE P0_SYSCNFG                                              /*���ð����ѵ�*/
SET DATANAME = to_char(:ll_juthando)
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND ( "P0_SYSCNFG"."SERIAL" = 24 ) AND 
      ( "P0_SYSCNFG"."LINENO" = '11' )   ;	

UPDATE P0_SYSCNFG                                              /*�ѵ���αݰ�����*/
SET DATANAME = to_char(:ll_gibuhanper)
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND ( "P0_SYSCNFG"."SERIAL" = 24 ) AND 
      ( "P0_SYSCNFG"."LINENO" = '12' )   ;	

UPDATE P0_SYSCNFG                                              /*ǥ�ذ����ѵ�*/
SET DATANAME = to_char(:ll_standgong)
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND ( "P0_SYSCNFG"."SERIAL" = 24 ) AND 
      ( "P0_SYSCNFG"."LINENO" = '13' )   ;


UPDATE P0_SYSCNFG                                              /*���ο������������*/
SET DATANAME = to_char(:ll_gayunsaveper)
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND ( "P0_SYSCNFG"."SERIAL" = 24 ) AND 
      ( "P0_SYSCNFG"."LINENO" = '14' )   ;

UPDATE P0_SYSCNFG                                              /*���ο����������*/
SET DATANAME = to_char(:ll_gayunsave)
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND ( "P0_SYSCNFG"."SERIAL" = 24 ) AND 
      ( "P0_SYSCNFG"."LINENO" = '15' )   ;


UPDATE P0_SYSCNFG                                             /*������������ѵ�*/
SET DATANAME = to_char(:ll_yunsave)
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND ( "P0_SYSCNFG"."SERIAL" = 24 ) AND 
      ( "P0_SYSCNFG"."LINENO" = '16' )   ;

UPDATE P0_SYSCNFG                                             /*�������հ�����*/
SET DATANAME = to_char(:ll_tujaper)
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND ( "P0_SYSCNFG"."SERIAL" = 24 ) AND 
      ( "P0_SYSCNFG"."LINENO" = '17' )   ;


UPDATE P0_SYSCNFG                                              /*�������հ���(�ҵ�ݾ�)�ѵ���*/
SET DATANAME = to_char(:ll_tujahanper)
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND ( "P0_SYSCNFG"."SERIAL" = 24 ) AND 
      ( "P0_SYSCNFG"."LINENO" = '18' )   ;


UPDATE P0_SYSCNFG                                              /*ī������ѱ޿�������*/
SET DATANAME = to_char(:ll_cardpayper)
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND ( "P0_SYSCNFG"."SERIAL" = 24 ) AND 
      ( "P0_SYSCNFG"."LINENO" = '19' )   ;


UPDATE P0_SYSCNFG                                              /*ī�����������*/
SET DATANAME = to_char(:ll_cardper)
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND ( "P0_SYSCNFG"."SERIAL" = 24 ) AND 
      ( "P0_SYSCNFG"."LINENO" = '20' )   ;


UPDATE P0_SYSCNFG                                              /*ī������ѵ�*/
SET DATANAME = to_char(:ll_cardhando)
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND ( "P0_SYSCNFG"."SERIAL" = 24 ) AND 
      ( "P0_SYSCNFG"."LINENO" = '21' )   ;

string ls_san1, ls_san2, ls_san3, ls_san4

ls_san1 = string(ll_san1,'00000000')
ls_san1 = ls_san1 + string(ll_san1_1,'000000000')
ls_san1 = ls_san1 + string(ll_san1per,'000')
ls_san1 = ls_san1 + string(ll_san11,'00000000')

UPDATE P0_SYSCNFG                                              /*����ǥ��(����������)*/ 		
SET DATANAME = :ls_san1
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND ( "P0_SYSCNFG"."SERIAL" = 20 ) AND
      ( "P0_SYSCNFG"."LINENO" = '1' )   ;


ls_san2 = string(ll_san2,'00000000')
ls_san2 = ls_san2 + string(ll_san2_1,'000000000')
ls_san2 = ls_san2 + string(ll_san2per,'000')
ls_san2 = ls_san2 + string(ll_san22,'00000000')

UPDATE P0_SYSCNFG                                              /*����ǥ��(����������)*/ 		
SET DATANAME = :ls_san2
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND ( "P0_SYSCNFG"."SERIAL" = 20 ) AND
      ( "P0_SYSCNFG"."LINENO" = '2' )   ;
		
ls_san3 = string(ll_san3,'00000000')
ls_san3 = ls_san3 + string(ll_san3_1,'000000000')
ls_san3 = ls_san3 + string(ll_san3per,'000')
ls_san3 = ls_san3 + string(ll_san33,'00000000')


UPDATE P0_SYSCNFG                                              /*����ǥ��(����������)*/ 		
SET DATANAME = :ls_san3
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND ( "P0_SYSCNFG"."SERIAL" = 20 ) AND
      ( "P0_SYSCNFG"."LINENO" = '3' )   ;
		
		
ls_san4 = string(ll_san4,'00000000')
ls_san4 = ls_san4 + string(ll_san4_1,'000000000')
ls_san4 = ls_san4 + string(ll_san4per,'000')
ls_san4 = ls_san4 + string(ll_san44,'00000000')

UPDATE P0_SYSCNFG                                              /*����ǥ��(����������)*/ 		
SET DATANAME = :ls_san4
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND ( "P0_SYSCNFG"."SERIAL" = 20 ) AND
      ( "P0_SYSCNFG"."LINENO" = '4' )   ;		
		

UPDATE P0_SYSCNFG                                              /*���װ��� ���رݾ�*/	
SET DATANAME = to_char(:ll_sangi)
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND ( "P0_SYSCNFG"."SERIAL" = 26 ) AND
      ( "P0_SYSCNFG"."LINENO" = '0' )   ;		
		
UPDATE P0_SYSCNFG                                              /*���װ��� ���رݾ� ���� ����*/
SET DATANAME = to_char(:ll_sanehaper)
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND ( "P0_SYSCNFG"."SERIAL" = 26 ) AND
      ( "P0_SYSCNFG"."LINENO" = '1' )   ;	


UPDATE P0_SYSCNFG                                              /*���װ��� ���رݾ� �ʰ� ����*/
SET DATANAME = to_char(:ll_sanchoper)
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND ( "P0_SYSCNFG"."SERIAL" = 26 ) AND
      ( "P0_SYSCNFG"."LINENO" = '2' )   ;	


UPDATE P0_SYSCNFG                                              /*���װ����ѵ��ݾ�*/
SET DATANAME = to_char(:ll_sankunhan)
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND ( "P0_SYSCNFG"."SERIAL" = 26 ) AND
      ( "P0_SYSCNFG"."LINENO" = '3' )   ;	


UPDATE P0_SYSCNFG                                              /*�����ڱݼ��װ�����*/
SET DATANAME = to_char(:ll_jutseackper)
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND ( "P0_SYSCNFG"."SERIAL" = 26 ) AND
      ( "P0_SYSCNFG"."LINENO" = '4' )   ;	


UPDATE P0_SYSCNFG                                              /*������Ǵ��ذ�����*/
SET DATANAME = to_char(:ll_jangikum)
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND ( "P0_SYSCNFG"."SERIAL" = 26 ) AND
      ( "P0_SYSCNFG"."LINENO" = '5' )   ;	


UPDATE P0_SYSCNFG                                              /*����������������*/
SET DATANAME = to_char(:ll_jangiago)
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND ( "P0_SYSCNFG"."SERIAL" = 26 ) AND
      ( "P0_SYSCNFG"."LINENO" = '6' )   ;	


UPDATE P0_SYSCNFG                                              /*�����ҵ������*/
SET DATANAME = to_char(:ll_tjper)
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND ( "P0_SYSCNFG"."SERIAL" = 40 ) AND
      ( "P0_SYSCNFG"."LINENO" = '1' )   ;	


string ll_tj1, ll_tj2, ll_tj3, ll_tj4

ll_tj1 = string(ll_tjyear1,'00')
ll_tj1 = ll_tj1 + string(ll_tjyear1_1,'00')
ll_tj1 = ll_tj1 + string(ll_tjyear1amt,'00000000')
ll_tj1 = ll_tj1 + string(ll_tjyear11,'0000000')

UPDATE P0_SYSCNFG                                              /*�����ҵ�ټӳ���� ����*/		
SET DATANAME = :ll_tj1
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND ( "P0_SYSCNFG"."SERIAL" = 41 ) AND
      ( "P0_SYSCNFG"."LINENO" = '1' )   ;
		
ll_tj2 = string(ll_tjyear2,'00')
ll_tj2 = ll_tj2 + string(ll_tjyear2_1,'00')
ll_tj2 = ll_tj2 + string(ll_tjyear2amt,'00000000')
ll_tj2 = ll_tj2 + string(ll_tjyear22,'0000000')

UPDATE P0_SYSCNFG                                              /*�����ҵ�ټӳ���� ����*/		
SET DATANAME = :ll_tj2
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND ( "P0_SYSCNFG"."SERIAL" = 41 ) AND
      ( "P0_SYSCNFG"."LINENO" = '2' )   ;
		
		
ll_tj3 = string(ll_tjyear3,'00')
ll_tj3 = ll_tj3 + string(ll_tjyear3_1,'00')
ll_tj3 = ll_tj3 + string(ll_tjyear3amt,'00000000')
ll_tj3 = ll_tj3 + string(ll_tjyear33,'0000000')

UPDATE P0_SYSCNFG                                              /*�����ҵ�ټӳ���� ����*/		
SET DATANAME = :ll_tj3
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND ( "P0_SYSCNFG"."SERIAL" = 41 ) AND
      ( "P0_SYSCNFG"."LINENO" = '3' )   ;
		
		
ll_tj4 = string(ll_tjyear4,'00')
ll_tj4 = ll_tj4 + string(ll_tjyear4_1,'00')
ll_tj4 = ll_tj4 + string(ll_tjyear4amt,'00000000')
ll_tj4 = ll_tj4 + string(ll_tjyear44,'0000000')

UPDATE P0_SYSCNFG                                              /*�����ҵ�ټӳ���� ����*/		
SET DATANAME = :ll_tj4
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND ( "P0_SYSCNFG"."SERIAL" = 41 ) AND
      ( "P0_SYSCNFG"."LINENO" = '4' )   ;
		

UPDATE P0_SYSCNFG                                             /*�����ҵ漼�װ�����*/		
SET DATANAME = to_char(:ll_tjseackgong)
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND ( "P0_SYSCNFG"."SERIAL" = 42 ) AND
      ( "P0_SYSCNFG"."LINENO" = '1' )   ;

UPDATE P0_SYSCNFG                                             /*�����ҵ�����ѵ���*/		
SET DATANAME = to_char(:ll_tjseackhan)
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND ( "P0_SYSCNFG"."SERIAL" = 42 ) AND
      ( "P0_SYSCNFG"."LINENO" = '2' )   ;


UPDATE P0_SYSCNFG                                             /*�����ҵ�����ѵ���*/		
SET DATANAME = to_char(:ll_tjseackhan)
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND ( "P0_SYSCNFG"."SERIAL" = 42 ) AND
      ( "P0_SYSCNFG"."LINENO" = '2' )   ;
		
		
UPDATE P0_SYSCNFG                                              /*��뺸�������*/		
SET DATANAME = to_char(:ld_goyungper)
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND ( "P0_SYSCNFG"."SERIAL" = 18 ) AND
      ( "P0_SYSCNFG"."LINENO" = '1' )   ;
		

UPDATE P0_SYSCNFG                                              /*����ȸ�������*/	
SET DATANAME = to_char(:ld_nojoper)
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND ( "P0_SYSCNFG"."SERIAL" = 17 ) AND
      ( "P0_SYSCNFG"."LINENO" = '1' )   ;
		

UPDATE P0_SYSCNFG                                              /*���ȸ�������*/
SET DATANAME = to_char(:ll_sawoo)
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND ( "P0_SYSCNFG"."SERIAL" = 16 ) AND
      ( "P0_SYSCNFG"."LINENO" = '1' )   ;
		
		
UPDATE P0_SYSCNFG                                              /*������������*/
SET DATANAME = :ls_bdate
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND ( "P0_SYSCNFG"."SERIAL" = 4 ) AND
      ( "P0_SYSCNFG"."LINENO" = '1' )   ;
		
		
UPDATE P0_SYSCNFG                                             /*�޿�������*/
SET DATANAME = :ls_pdate
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND ( "P0_SYSCNFG"."SERIAL" = 10 ) AND
      ( "P0_SYSCNFG"."LINENO" = '1' )   ;
		
		
UPDATE P0_SYSCNFG                                             /*�������ڵ�*/
SET DATANAME = :ls_semuse
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND ( "P0_SYSCNFG"."SERIAL" = 70 ) AND
      ( "P0_SYSCNFG"."LINENO" = '1' )   ;
		
		
UPDATE P0_SYSCNFG                                              /*������ü��ȣ*/
SET DATANAME = :ls_ptongno
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND ( "P0_SYSCNFG"."SERIAL" = 55 ) AND
      ( "P0_SYSCNFG"."LINENO" = '1' )   ;			
		
UPDATE P0_SYSCNFG                                              /*�����ϱٷ��ϼ����Կ���*/
SET DATANAME = :ls_tjdaygubn
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND ( "P0_SYSCNFG"."SERIAL" = 43 ) AND
      ( "P0_SYSCNFG"."LINENO" = '1' )   ;			

UPDATE P0_SYSCNFG                                              /*�ݾ����翩��*/
SET DATANAME = :amtgbn
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND ( "P0_SYSCNFG"."SERIAL" = 60 ) AND
      ( "P0_SYSCNFG"."LINENO" = '1' )   ;			




if sqlca.sqlcode = 0 then
	commit using sqlca;
	w_mdi_frame.sle_msg.text = '�����Ͽ����ϴ�!'
else
	rollback;
	w_mdi_frame.sle_msg.text = '�������!'
end if
	
Setpointer(Arrow!)
end event

type p_del from w_inherite_standard`p_del within w_piz2001
boolean visible = false
integer x = 3529
integer y = 3836
end type

type p_inq from w_inherite_standard`p_inq within w_piz2001
integer x = 4069
end type

event p_inq::clicked;call super::clicked;string ls_woncode, ls_sikcode
string ls_bdate, ls_pdate, ls_semuse, ls_ptongno
long ll_wonjun, ll_sikdae, ll_yjfree, ll_woljung, ll_jyhando
long ll_kun1, ll_kun1_1, ll_kun1per, ll_kun11, ll_kun2, ll_kun2_1, ll_kun2per, ll_kun22
long ll_kun3, ll_kun3_1, ll_kun3per, ll_kun33, ll_kun4, ll_kun4_1, ll_kun4per, ll_kun44
long ll_kun5, ll_kun5_1, ll_kun5per, ll_kun55
long ll_gigong,ll_baegong,ll_bugong,ll_janggong,ll_gyungong,ll_bunygong,ll_matgong,ll_sosugong1,ll_sosugong2
long ll_bohum,ll_jbohum,ll_medper, ll_medhando,ll_yuchigong,ll_cjgogong,ll_daehakgong
long ll_jutper,ll_juthando,ll_gibuhanper,ll_standgong,ll_gayunsaveper,ll_gayunsave,ll_yunsave
long ll_tujaper,ll_tujahanper,ll_cardpayper,ll_cardper,ll_cardhando
long ll_jutchper, ll_jutchong
long ll_san1, ll_san1_1, ll_san1per, ll_san11, ll_san2, ll_san2_1, ll_san2per, ll_san22
long ll_san3, ll_san3_1, ll_san3per, ll_san33, ll_san4, ll_san4_1, ll_san4per, ll_san44
long ll_sangi,ll_sanehaper,ll_sanchoper,ll_sankunhan,ll_jutseackper,ll_jangikum,ll_jangiago
long ll_tjper
long ll_tjyear1, ll_tjyear1_1, ll_tjyear1amt, ll_tjyear11
long ll_tjyear2, ll_tjyear2_1, ll_tjyear2amt, ll_tjyear22
long ll_tjyear3, ll_tjyear3_1, ll_tjyear3amt, ll_tjyear33
long ll_tjyear4, ll_tjyear4_1, ll_tjyear4amt, ll_tjyear44
long ll_tjseackhan, ll_tjseackgong
long ll_sawoo
double ld_goyungper, ld_nojoper



dw_list.setredraw(false)
dw_list.reset()
dw_list.insertrow(0)



SELECT SUBSTR("P0_SYSCNFG"."DATANAME",1,2)				   			/*�������������ڵ�*/
INTO :ls_woncode  
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND ( "P0_SYSCNFG"."SERIAL" = 28 ) AND ( "P0_SYSCNFG"."LINENO" = '1' )   ;


SELECT TO_NUMBER(SUBSTR("P0_SYSCNFG"."DATANAME",3,8))				   			/*��������*/
INTO :ll_wonjun  
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND ( "P0_SYSCNFG"."SERIAL" = 28 ) AND ( "P0_SYSCNFG"."LINENO" = '1' )   ;


SELECT SUBSTR("P0_SYSCNFG"."DATANAME",1,2)				      	           /*�Ĵ�����ڵ�*/
INTO :ls_sikcode
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND ( "P0_SYSCNFG"."SERIAL" = 28 ) AND ( "P0_SYSCNFG"."LINENO" = '2' )   ;
  
																								 /*�Ĵ�*/	
SELECT TO_NUMBER(SUBSTR("P0_SYSCNFG"."DATANAME",3,8))						
INTO :ll_sikdae
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND ( "P0_SYSCNFG"."SERIAL" = 28 ) AND ( "P0_SYSCNFG"."LINENO" = '2' )   ;

																					   		/*����,�߰�*/	
SELECT TO_NUMBER(SUBSTR("P0_SYSCNFG"."DATANAME",1,8))
INTO :ll_yjfree 
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND ( "P0_SYSCNFG"."SERIAL" = 28 ) AND ( "P0_SYSCNFG"."LINENO" = '3' )   ;

																						     /*�����޿�*/	
SELECT TO_NUMBER(SUBSTR("P0_SYSCNFG"."DATANAME",1,8))
INTO :ll_woljung
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND ( "P0_SYSCNFG"."SERIAL" = 28 ) AND ( "P0_SYSCNFG"."LINENO" = '4' ) ;

 
                                                                       /*����߰��������ѵ�*/	
SELECT TO_NUMBER(SUBSTR("P0_SYSCNFG"."DATANAME",1,8))                     
INTO :ll_jyhando
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND ( "P0_SYSCNFG"."SERIAL" = 28 ) AND ( "P0_SYSCNFG"."LINENO" = '0' ) ;


                                                                      /* �ٷμҵ����*/ 
SELECT To_Number(Substr(SUBSTR("P0_SYSCNFG"."DATANAME",1,50),1,8)),
       To_Number(Substr(SUBSTR("P0_SYSCNFG"."DATANAME",1,50),9,9)),
       To_Number(Substr(SUBSTR("P0_SYSCNFG"."DATANAME",1,50),18,3)),
       To_Number(Substr(SUBSTR("P0_SYSCNFG"."DATANAME",1,50),21,9))
INTO   :ll_kun1, :ll_kun1_1, :ll_kun1per, :ll_kun11
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  ( "P0_SYSCNFG"."SERIAL" = 21 ) AND
   	( "P0_SYSCNFG"."LINENO" = '1' );

SELECT To_Number(Substr(SUBSTR("P0_SYSCNFG"."DATANAME",1,50),1,8)),
       To_Number(Substr(SUBSTR("P0_SYSCNFG"."DATANAME",1,50),9,9)),
       To_Number(Substr(SUBSTR("P0_SYSCNFG"."DATANAME",1,50),18,3)),
       To_Number(Substr(SUBSTR("P0_SYSCNFG"."DATANAME",1,50),21,9))
INTO   :ll_kun2, :ll_kun2_1, :ll_kun2per, :ll_kun22
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  ( "P0_SYSCNFG"."SERIAL" = 21 ) AND
   	( "P0_SYSCNFG"."LINENO" = '2' );

SELECT To_Number(Substr(SUBSTR("P0_SYSCNFG"."DATANAME",1,50),1,8)),
       To_Number(Substr(SUBSTR("P0_SYSCNFG"."DATANAME",1,50),9,9)),
       To_Number(Substr(SUBSTR("P0_SYSCNFG"."DATANAME",1,50),18,3)),
       To_Number(Substr(SUBSTR("P0_SYSCNFG"."DATANAME",1,50),21,9))
INTO   :ll_kun3, :ll_kun3_1, :ll_kun3per, :ll_kun33
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  ( "P0_SYSCNFG"."SERIAL" = 21 ) AND
   	( "P0_SYSCNFG"."LINENO" = '3' );

SELECT To_Number(Substr(SUBSTR("P0_SYSCNFG"."DATANAME",1,50),1,8)),
       To_Number(Substr(SUBSTR("P0_SYSCNFG"."DATANAME",1,50),9,9)),
       To_Number(Substr(SUBSTR("P0_SYSCNFG"."DATANAME",1,50),18,3)),
       To_Number(Substr(SUBSTR("P0_SYSCNFG"."DATANAME",1,50),21,9))
INTO   :ll_kun4, :ll_kun4_1, :ll_kun4per, :ll_kun44
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  ( "P0_SYSCNFG"."SERIAL" = 21 ) AND
   	( "P0_SYSCNFG"."LINENO" = '4' );

SELECT To_Number(Substr(SUBSTR("P0_SYSCNFG"."DATANAME",1,50),1,8)),
       To_Number(Substr(SUBSTR("P0_SYSCNFG"."DATANAME",1,50),9,9)),
       To_Number(Substr(SUBSTR("P0_SYSCNFG"."DATANAME",1,50),18,3)),
       To_Number(Substr(SUBSTR("P0_SYSCNFG"."DATANAME",1,50),21,9))
INTO   :ll_kun5, :ll_kun5_1, :ll_kun5per, :ll_kun55
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  ( "P0_SYSCNFG"."SERIAL" = 21 ) AND
   	( "P0_SYSCNFG"."LINENO" = '5' );


SELECT TO_Number(SUBSTR("P0_SYSCNFG"."DATANAME",1,50))							/*���ʰ���*/
INTO :ll_gigong
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  ( "P0_SYSCNFG"."SERIAL" = 22 ) AND
      ( "P0_SYSCNFG"."LINENO" = '1') ;


SELECT TO_Number(SUBSTR("P0_SYSCNFG"."DATANAME",1,50))							/*����ڰ���*/
INTO :ll_baegong
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  ( "P0_SYSCNFG"."SERIAL" = 22 ) AND
   	( "P0_SYSCNFG"."LINENO" = '2') ;

SELECT TO_Number(SUBSTR("P0_SYSCNFG"."DATANAME",1,50))							/*�ξ��ڰ���*/
INTO :ll_bugong
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  ( "P0_SYSCNFG"."SERIAL" = 22 ) AND
	   ( "P0_SYSCNFG"."LINENO" = '3') ;

SELECT TO_Number(SUBSTR("P0_SYSCNFG"."DATANAME",1,50))							/*����ڰ���*/
INTO :ll_janggong
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  ( "P0_SYSCNFG"."SERIAL" = 23 ) AND
	   ( "P0_SYSCNFG"."LINENO" = '1') ;

SELECT TO_Number(SUBSTR("P0_SYSCNFG"."DATANAME",1,50))							/*��ο�����*/
INTO :ll_gyungong
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  ( "P0_SYSCNFG"."SERIAL" = 23 ) AND
	   ( "P0_SYSCNFG"."LINENO" = '2') ;

SELECT TO_Number(SUBSTR("P0_SYSCNFG"."DATANAME",1,50))							/*�γ��ڰ���*/
INTO :ll_bunygong
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  ( "P0_SYSCNFG"."SERIAL" = 23 ) AND
	   ( "P0_SYSCNFG"."LINENO" = '3') ;

SELECT TO_Number(SUBSTR("P0_SYSCNFG"."DATANAME",1,50))							/*�ڳ���������*/
INTO :ll_matgong
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  ( "P0_SYSCNFG"."SERIAL" = 23 ) AND
	   ( "P0_SYSCNFG"."LINENO" = '4') ;

SELECT TO_Number(SUBSTR("P0_SYSCNFG"."DATANAME",1,50))							/*�Ҽ�����1*/
INTO :ll_sosugong1
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  ( "P0_SYSCNFG"."SERIAL" = 23 ) AND
	   ( "P0_SYSCNFG"."LINENO" = '5') ;

SELECT TO_Number(SUBSTR("P0_SYSCNFG"."DATANAME",1,50))							/*�Ҽ�����2*/
INTO :ll_sosugong2
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  ( "P0_SYSCNFG"."SERIAL" = 23 ) AND
	   ( "P0_SYSCNFG"."LINENO" = '6') ;


SELECT TO_Number(SUBSTR("P0_SYSCNFG"."DATANAME",1,50))							/*�������*/
INTO :ll_bohum
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  ( "P0_SYSCNFG"."SERIAL" = 24 ) AND
	   ( "P0_SYSCNFG"."LINENO" = '1') ;


SELECT TO_Number(SUBSTR("P0_SYSCNFG"."DATANAME",1,50))							/*��ֺ������*/
INTO :ll_jbohum
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  ( "P0_SYSCNFG"."SERIAL" = 24 ) AND
	   ( "P0_SYSCNFG"."LINENO" = '2') ;


SELECT TO_Number(SUBSTR("P0_SYSCNFG"."DATANAME",1,50))							/*�Ƿ�������*/
INTO :ll_medper
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  ( "P0_SYSCNFG"."SERIAL" = 24 ) AND
	   ( "P0_SYSCNFG"."LINENO" = '3') ;


SELECT TO_Number(SUBSTR("P0_SYSCNFG"."DATANAME",1,50))							/*�Ƿ�����*/
INTO :ll_medhando
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  ( "P0_SYSCNFG"."SERIAL" = 24 ) AND
	   ( "P0_SYSCNFG"."LINENO" = '4') ;


SELECT TO_Number(SUBSTR("P0_SYSCNFG"."DATANAME",1,50))							/*��ġ�����������*/
INTO :ll_yuchigong
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  ( "P0_SYSCNFG"."SERIAL" = 24 ) AND
	   ( "P0_SYSCNFG"."LINENO" = '5') ;

SELECT TO_Number(SUBSTR("P0_SYSCNFG"."DATANAME",1,50))							/*���߰��������*/
INTO :ll_cjgogong
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  ( "P0_SYSCNFG"."SERIAL" = 24 ) AND
	   ( "P0_SYSCNFG"."LINENO" = '6') ;

SELECT TO_Number(SUBSTR("P0_SYSCNFG"."DATANAME",1,50))							/*���б����������*/
INTO :ll_daehakgong
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  ( "P0_SYSCNFG"."SERIAL" = 24 ) AND
	   ( "P0_SYSCNFG"."LINENO" = '7') ;


SELECT TO_Number(SUBSTR("P0_SYSCNFG"."DATANAME",1,50))							/*���ø��ð�����*/
INTO :ll_jutper
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  ( "P0_SYSCNFG"."SERIAL" = 24 ) AND
	   ( "P0_SYSCNFG"."LINENO" = '8') ;


SELECT TO_Number(SUBSTR("P0_SYSCNFG"."DATANAME",1,50))							/*���ÿ����ݻ�ȯ������*/
INTO :ll_jutchper
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  ( "P0_SYSCNFG"."SERIAL" = 24 ) AND
	   ( "P0_SYSCNFG"."LINENO" = '9') ;


SELECT TO_Number(SUBSTR("P0_SYSCNFG"."DATANAME",1,50))							/*����û��α��ѵ�*/
INTO :ll_jutchong
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  ( "P0_SYSCNFG"."SERIAL" = 24 ) AND
	   ( "P0_SYSCNFG"."LINENO" = '10') ;


SELECT TO_Number(SUBSTR("P0_SYSCNFG"."DATANAME",1,50))							/*���ð����ѵ�*/
INTO :ll_juthando
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  ( "P0_SYSCNFG"."SERIAL" = 24 ) AND
	   ( "P0_SYSCNFG"."LINENO" = '11') ;


SELECT TO_Number(SUBSTR("P0_SYSCNFG"."DATANAME",1,50))							/*�ѵ���αݰ�����*/
INTO :ll_gibuhanper
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  ( "P0_SYSCNFG"."SERIAL" = 24 ) AND
	   ( "P0_SYSCNFG"."LINENO" = '12') ;


SELECT TO_Number(SUBSTR("P0_SYSCNFG"."DATANAME",1,50))							/*ǥ�ذ����ѵ�*/
INTO :ll_standgong
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  ( "P0_SYSCNFG"."SERIAL" = 24 ) AND
	   ( "P0_SYSCNFG"."LINENO" = '13') ;


SELECT TO_Number(SUBSTR("P0_SYSCNFG"."DATANAME",1,50))							/*���ο������������*/
INTO :ll_gayunsaveper
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  ( "P0_SYSCNFG"."SERIAL" = 24 ) AND
	   ( "P0_SYSCNFG"."LINENO" = '14') ;


SELECT TO_Number(SUBSTR("P0_SYSCNFG"."DATANAME",1,50))							/*���ο����������*/
INTO :ll_gayunsave
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  ( "P0_SYSCNFG"."SERIAL" = 24 ) AND
	   ( "P0_SYSCNFG"."LINENO" = '15') ;


SELECT TO_Number(SUBSTR("P0_SYSCNFG"."DATANAME",1,50))							/*������������ѵ�*/
INTO :ll_yunsave
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  ( "P0_SYSCNFG"."SERIAL" = 24 ) AND
	   ( "P0_SYSCNFG"."LINENO" = '16') ;


SELECT TO_Number(SUBSTR("P0_SYSCNFG"."DATANAME",1,50))							/*�������հ�����*/
INTO :ll_tujaper
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  ( "P0_SYSCNFG"."SERIAL" = 24 ) AND
	   ( "P0_SYSCNFG"."LINENO" = '17') ;


SELECT TO_Number(SUBSTR("P0_SYSCNFG"."DATANAME",1,50))							/*�������հ���(�ҵ�ݾ�)�ѵ���*/
INTO :ll_tujahanper
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  ( "P0_SYSCNFG"."SERIAL" = 24 ) AND
	   ( "P0_SYSCNFG"."LINENO" = '18') ;


SELECT TO_Number(SUBSTR("P0_SYSCNFG"."DATANAME",1,50))							/*ī������ѱ޿�������*/
INTO :ll_cardpayper
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  ( "P0_SYSCNFG"."SERIAL" = 24 ) AND
	   ( "P0_SYSCNFG"."LINENO" = '19') ;


SELECT TO_Number(SUBSTR("P0_SYSCNFG"."DATANAME",1,50))							/*ī�����������*/
INTO :ll_cardper
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  ( "P0_SYSCNFG"."SERIAL" = 24 ) AND
	   ( "P0_SYSCNFG"."LINENO" = '20') ;


SELECT TO_Number(SUBSTR("P0_SYSCNFG"."DATANAME",1,50))							/*ī������ѵ�*/
INTO :ll_cardhando
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  ( "P0_SYSCNFG"."SERIAL" = 24 ) AND
	   ( "P0_SYSCNFG"."LINENO" = '21') ;


                                                                          /*����ǥ��(����������)*/    
SELECT To_Number(SUBSTR("P0_SYSCNFG"."DATANAME",1,8)),
		 To_Number(SUBSTR("P0_SYSCNFG"."DATANAME",9,9)),
		 To_Number(SUBSTR("P0_SYSCNFG"."DATANAME",18,3)),
		 To_Number(SUBSTR("P0_SYSCNFG"."DATANAME",21,8))
INTO   :ll_san1, :ll_san1_1, :ll_san1per, :ll_san11
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  ( "P0_SYSCNFG"."SERIAL" = 20 ) AND
		( "P0_SYSCNFG"."LINENO" = '1');


SELECT To_Number(SUBSTR("P0_SYSCNFG"."DATANAME",1,8)),
		 To_Number(SUBSTR("P0_SYSCNFG"."DATANAME",9,9)),
		 To_Number(SUBSTR("P0_SYSCNFG"."DATANAME",18,3)),
		 To_Number(SUBSTR("P0_SYSCNFG"."DATANAME",21,8))
INTO   :ll_san2, :ll_san2_1, :ll_san2per, :ll_san22
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  ( "P0_SYSCNFG"."SERIAL" = 20 ) AND
		( "P0_SYSCNFG"."LINENO" = '2');


SELECT To_Number(SUBSTR("P0_SYSCNFG"."DATANAME",1,8)),
		 To_Number(SUBSTR("P0_SYSCNFG"."DATANAME",9,9)),
		 To_Number(SUBSTR("P0_SYSCNFG"."DATANAME",18,3)),
		 To_Number(SUBSTR("P0_SYSCNFG"."DATANAME",21,8))
INTO   :ll_san3, :ll_san3_1, :ll_san3per, :ll_san33
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  ( "P0_SYSCNFG"."SERIAL" = 20 ) AND
		( "P0_SYSCNFG"."LINENO" = '3');


SELECT To_Number(SUBSTR("P0_SYSCNFG"."DATANAME",1,8)),
		 To_Number(SUBSTR("P0_SYSCNFG"."DATANAME",9,9)),
		 To_Number(SUBSTR("P0_SYSCNFG"."DATANAME",18,3)),
		 To_Number(SUBSTR("P0_SYSCNFG"."DATANAME",21,8))
INTO   :ll_san4, :ll_san4_1, :ll_san4per, :ll_san44
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  ( "P0_SYSCNFG"."SERIAL" = 20 ) AND
		( "P0_SYSCNFG"."LINENO" = '4');


SELECT To_Number(SUBSTR("P0_SYSCNFG"."DATANAME",1,7))				/*���װ��� ���رݾ�*/
INTO :ll_sangi
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  ( "P0_SYSCNFG"."SERIAL" = 26 ) AND
		( "P0_SYSCNFG"."LINENO" = '0');


SELECT To_Number(SUBSTR("P0_SYSCNFG"."DATANAME",1,3))				/*���װ��� ���رݾ� ���� ����*/
INTO :ll_sanehaper
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  ( "P0_SYSCNFG"."SERIAL" = 26 ) AND
		( "P0_SYSCNFG"."LINENO" = '1');


SELECT To_Number(SUBSTR("P0_SYSCNFG"."DATANAME",1,3))				/*���װ��� ���رݾ� �ʰ� ����*/
INTO :ll_sanchoper
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  ( "P0_SYSCNFG"."SERIAL" = 26 ) AND
		( "P0_SYSCNFG"."LINENO" = '2');


SELECT To_Number(SUBSTR("P0_SYSCNFG"."DATANAME",1,7))				/*���װ����ѵ��ݾ�*/
INTO :ll_sankunhan
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  ( "P0_SYSCNFG"."SERIAL" = 26 ) AND
		( "P0_SYSCNFG"."LINENO" = '3');


SELECT To_Number(SUBSTR("P0_SYSCNFG"."DATANAME",1,3))				/*�����ڱݼ��װ�����*/
INTO :ll_jutseackper
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  ( "P0_SYSCNFG"."SERIAL" = 26 ) AND
		( "P0_SYSCNFG"."LINENO" = '4');


SELECT To_Number(SUBSTR("P0_SYSCNFG"."DATANAME",1,3))				/*������Ǵ��ذ�����*/
INTO :ll_jangikum
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  ( "P0_SYSCNFG"."SERIAL" = 26 ) AND
		( "P0_SYSCNFG"."LINENO" = '5');


SELECT To_Number(SUBSTR("P0_SYSCNFG"."DATANAME",1,3))				/*����������������*/
INTO :ll_jangiago
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  ( "P0_SYSCNFG"."SERIAL" = 26 ) AND
		( "P0_SYSCNFG"."LINENO" = '6');



SELECT To_Number(Substr(SUBSTR("P0_SYSCNFG"."DATANAME",1,50),1,3))   /*�����ҵ������*/
INTO   :ll_tjper
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  ( "P0_SYSCNFG"."SERIAL" = 40 ) AND
   	( "P0_SYSCNFG"."LINENO" = '1' );

SELECT To_Number(Substr(SUBSTR("P0_SYSCNFG"."DATANAME",1,50),1,2)),   /*�����ҵ�ټӳ���� ����*/
       To_Number(Substr(SUBSTR("P0_SYSCNFG"."DATANAME",1,50),3,2)),
       To_Number(Substr(SUBSTR("P0_SYSCNFG"."DATANAME",1,50),5,8)),
       To_Number(Substr(SUBSTR("P0_SYSCNFG"."DATANAME",1,50),13,7))
INTO   :ll_tjyear1, :ll_tjyear1_1, :ll_tjyear1amt, :ll_tjyear11
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  ( "P0_SYSCNFG"."SERIAL" = 41 ) AND
   	( "P0_SYSCNFG"."LINENO" = '1' );
		
		
SELECT To_Number(Substr(SUBSTR("P0_SYSCNFG"."DATANAME",1,50),1,2)),
       To_Number(Substr(SUBSTR("P0_SYSCNFG"."DATANAME",1,50),3,2)),
       To_Number(Substr(SUBSTR("P0_SYSCNFG"."DATANAME",1,50),5,8)),
       To_Number(Substr(SUBSTR("P0_SYSCNFG"."DATANAME",1,50),13,7))
INTO   :ll_tjyear2, :ll_tjyear2_1, :ll_tjyear2amt, :ll_tjyear22
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  ( "P0_SYSCNFG"."SERIAL" = 41 ) AND
   	( "P0_SYSCNFG"."LINENO" = '2' );
		

SELECT To_Number(Substr(SUBSTR("P0_SYSCNFG"."DATANAME",1,50),1,2)),
       To_Number(Substr(SUBSTR("P0_SYSCNFG"."DATANAME",1,50),3,2)),
       To_Number(Substr(SUBSTR("P0_SYSCNFG"."DATANAME",1,50),5,8)),
       To_Number(Substr(SUBSTR("P0_SYSCNFG"."DATANAME",1,50),13,7))
INTO   :ll_tjyear3, :ll_tjyear3_1, :ll_tjyear3amt, :ll_tjyear33
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  ( "P0_SYSCNFG"."SERIAL" = 41 ) AND
   	( "P0_SYSCNFG"."LINENO" = '3' );
		
		
SELECT To_Number(Substr(SUBSTR("P0_SYSCNFG"."DATANAME",1,50),1,2)),
       To_Number(Substr(SUBSTR("P0_SYSCNFG"."DATANAME",1,50),3,2)),
       To_Number(Substr(SUBSTR("P0_SYSCNFG"."DATANAME",1,50),5,8)),
       To_Number(Substr(SUBSTR("P0_SYSCNFG"."DATANAME",1,50),13,7))
INTO   :ll_tjyear4, :ll_tjyear4_1, :ll_tjyear4amt, :ll_tjyear44
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  ( "P0_SYSCNFG"."SERIAL" = 41 ) AND
   	( "P0_SYSCNFG"."LINENO" = '4' );		



SELECT To_Number(Substr(SUBSTR("P0_SYSCNFG"."DATANAME",1,50),1,3))        /*�����ҵ漼�װ�����*/     
INTO   :ll_tjseackgong
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  ( "P0_SYSCNFG"."SERIAL" = 42 ) AND
   	( "P0_SYSCNFG"."LINENO" = '1' );


SELECT To_Number(Substr(SUBSTR("P0_SYSCNFG"."DATANAME",1,50),1,6))       /*�����ҵ�����ѵ���*/
INTO   :ll_tjseackhan
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  ( "P0_SYSCNFG"."SERIAL" = 42 ) AND
   	( "P0_SYSCNFG"."LINENO" = '2' );


SELECT To_Number(Substr(SUBSTR("P0_SYSCNFG"."DATANAME",1,50),1,6))       /*��뺸�������*/
INTO   :ld_goyungper 
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  ( "P0_SYSCNFG"."SERIAL" = 18 ) AND
   	( "P0_SYSCNFG"."LINENO" = '1' );
		
		
SELECT To_Number(Substr(SUBSTR("P0_SYSCNFG"."DATANAME",1,50),1,6))       /*����ȸ�������*/
INTO   :ld_nojoper
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  ( "P0_SYSCNFG"."SERIAL" = 17 ) AND
   	( "P0_SYSCNFG"."LINENO" = '1' );
		
		
SELECT To_Number(Substr(SUBSTR("P0_SYSCNFG"."DATANAME",1,50),1,6))       /*���ȸ�������*/
INTO   :ll_sawoo
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  ( "P0_SYSCNFG"."SERIAL" = 16 ) AND
   	( "P0_SYSCNFG"."LINENO" = '1' );	
		
		
SELECT rtrim("P0_SYSCNFG"."DATANAME")                             /*������������*/
INTO   :ls_bdate
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  ( "P0_SYSCNFG"."SERIAL" = 4) AND
   	( "P0_SYSCNFG"."LINENO" = '1' );		
		
		
SELECT rtrim("P0_SYSCNFG"."DATANAME")                              /*�޿�������*/
INTO   :ls_pdate
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  ( "P0_SYSCNFG"."SERIAL" = 10) AND
   	( "P0_SYSCNFG"."LINENO" = '1' );		
		
		
SELECT rtrim("P0_SYSCNFG"."DATANAME")                               /*�������ڵ�*/
INTO   :ls_semuse
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  ( "P0_SYSCNFG"."SERIAL" = 70) AND
   	( "P0_SYSCNFG"."LINENO" = '1' );				
		
		
SELECT rtrim("P0_SYSCNFG"."DATANAME")                          /*������ü��ȣ*/
INTO   :ls_ptongno
FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  ( "P0_SYSCNFG"."SERIAL" = 55) AND
   	( "P0_SYSCNFG"."LINENO" = '1' );				
		
		
dw_list.Setitem(1,"wonjun", ll_wonjun)
dw_list.Setitem(1,"woncode", ls_woncode)
dw_list.setitem(1,"sikdae",  ll_sikdae)
dw_list.setitem(1,"sikcode", ls_sikcode )
dw_list.setitem(1,"yjfree" ,ll_yjfree)
dw_list.setitem(1,"woljung" ,ll_woljung)
dw_list.setitem(1,"kun1" ,ll_kun1 )
dw_list.setitem(1,"kun1_1", ll_kun1_1)
dw_list.setitem(1,"kun11", ll_kun11 )
dw_list.setitem(1,"kun1per", ll_kun1per )
dw_list.setitem(1,"kun2", ll_kun2)
dw_list.setitem(1,"kun2_1", ll_kun2_1 )
dw_list.setitem(1,"kun22", ll_kun22 )
dw_list.setitem(1,"kun2per", ll_kun2per )
dw_list.setitem(1,"kun3", ll_kun3 )
dw_list.setitem(1,"kun3_1", ll_kun3_1 )
dw_list.setitem(1,"kun33", ll_kun33 )
dw_list.setitem(1,"kun3per", ll_kun3per)
dw_list.setitem(1,"kun4", ll_kun4 )
dw_list.setitem(1,"kun4_1", ll_kun4_1 )
dw_list.setitem(1,"kun44",ll_kun44)
dw_list.setitem(1,"kun4per", ll_kun4per)
dw_list.setitem(1,"kun5", ll_kun5 )
dw_list.setitem(1,"kun5_1", ll_kun5_1) 
dw_list.setitem(1,"kun55", ll_kun55 )
dw_list.setitem(1,"kun5per",ll_kun5per ) 
dw_list.setitem(1,"gigong" ,ll_gigong )
dw_list.setitem(1,"baegong" ,ll_baegong)
dw_list.setitem(1,"bugong" ,ll_bugong)
dw_list.setitem(1,"janggong", ll_janggong )
dw_list.setitem(1,"gyungong" ,ll_gyungong)
dw_list.setitem(1,"bunygong" ,ll_bunygong) 
dw_list.setitem(1,"matgong" ,ll_matgong )
dw_list.setitem(1,"sosugong1", ll_sosugong1 )
dw_list.setitem(1,"sosugong2" ,ll_sosugong2 )
dw_list.setitem(1,"yuchigong" ,ll_yuchigong)
dw_list.setitem(1,"cjgogong" ,ll_cjgogong )
dw_list.setitem(1,"daehakgong", ll_daehakgong )
dw_list.setitem(1,"medper" ,ll_medper )
dw_list.setitem(1,"medhando", ll_medhando)
dw_list.setitem(1,"bohum" ,ll_bohum)
dw_list.setitem(1,"jbohum" ,ll_jbohum)
dw_list.setitem(1,"jutper" ,ll_jutper)
dw_list.setitem(1,"jutchper", ll_jutchper)
dw_list.setitem(1,"jutchong" ,ll_jutchong)
dw_list.setitem(1,"juthando" ,ll_juthando)
dw_list.setitem(1,"gibuhanper", ll_gibuhanper)
dw_list.setitem(1,"standgong" , ll_standgong)
dw_list.setitem(1,"gayunsave" , ll_gayunsave)
dw_list.setitem(1,"gayunsaveper", ll_gayunsaveper)
dw_list.setitem(1,"yunsave" , ll_yunsave)
dw_list.setitem(1,"tujaper" , ll_tujaper)
dw_list.setitem(1,"tujahanper", ll_tujahanper)
dw_list.setitem(1,"cardpayper" , ll_cardpayper)
dw_list.setitem(1,"cardper" , ll_cardper)
dw_list.setitem(1,"cardhando", ll_cardhando)
dw_list.setitem(1,"san1" , ll_san1)
dw_list.setitem(1,"san1_1",  ll_san1_1)
dw_list.setitem(1,"san11" ,ll_san11)
dw_list.setitem(1,"san1per", ll_san1per)
dw_list.setitem(1,"san2" ,ll_san2 )
dw_list.setitem(1,"san2_1", ll_san2_1) 
dw_list.setitem(1,"san22" ,ll_san22)
dw_list.setitem(1,"san2per", ll_san2per)
dw_list.setitem(1,"san3" ,ll_san3)
dw_list.setitem(1,"san3_1", ll_san3_1 )
dw_list.setitem(1,"san33" ,ll_san33)
dw_list.setitem(1,"san3per", ll_san3per)
dw_list.setitem(1,"san4" ,ll_san4)
dw_list.setitem(1,"san4_1", ll_san4_1)
dw_list.setitem(1,"san44" ,ll_san44)
dw_list.setitem(1,"san4per", ll_san4per)
dw_list.setitem(1,"sangi" ,ll_sangi )
dw_list.setitem(1,"sanehaper", ll_sanehaper)
dw_list.setitem(1,"sanchoper", ll_sanchoper )
dw_list.setitem(1,"sankunhan" ,ll_sankunhan )
dw_list.setitem(1,"jutseackper", ll_jutseackper )
dw_list.setitem(1,"jangiago" ,ll_jangiago)
dw_list.setitem(1,"jangikum" ,ll_jangikum )
dw_list.setitem(1,"tjper" ,ll_tjper)
dw_list.setitem(1,"tjyear1", ll_tjyear1 )
dw_list.setitem(1,"tjyear1_1", ll_tjyear1_1) 
dw_list.setitem(1,"tjyear11" ,ll_tjyear11 )
dw_list.setitem(1,"tjyear1amt", ll_tjyear1amt )
dw_list.setitem(1,"tjyear2" ,ll_tjyear2 )
dw_list.setitem(1,"tjyear2_1", ll_tjyear2_1) 
dw_list.setitem(1,"tjyear22" ,ll_tjyear22 )
dw_list.setitem(1,"tjyear2amt", ll_tjyear2amt )
dw_list.setitem(1,"tjyear3" ,ll_tjyear3 )
dw_list.setitem(1,"tjyear3_1", ll_tjyear3_1) 
dw_list.setitem(1,"tjyear33" ,ll_tjyear33 )
dw_list.setitem(1,"tjyear3amt" ,ll_tjyear3amt)
dw_list.setitem(1,"tjyear4" ,ll_tjyear4)
dw_list.setitem(1,"tjyear4_1", ll_tjyear4_1)
dw_list.setitem(1,"tjyear44" ,ll_tjyear44 )
dw_list.setitem(1,"tjyear4amt", ll_tjyear4amt)
dw_list.setitem(1,"tjseackgong", ll_tjseackgong)
dw_list.setitem(1,"tjseackhan" ,ll_tjseackhan )
dw_list.setitem(1,"bdate",string(ls_bdate,'@@@@.@@.@@'))
dw_list.setitem(1,"pdate",ls_pdate)
dw_list.setitem(1,"semuse", ls_semuse)
dw_list.setitem(1,"ptongno",ls_ptongno)
dw_list.setitem(1,"goyungper",ld_goyungper)
dw_list.setitem(1,"nojoper",ld_nojoper)
dw_list.setitem(1,"sawoo",ll_sawoo)


dw_list.setredraw(true)

end event

type p_print from w_inherite_standard`p_print within w_piz2001
boolean visible = false
integer x = 3621
integer y = 3432
end type

type p_can from w_inherite_standard`p_can within w_piz2001
boolean visible = false
integer x = 3703
integer y = 3836
end type

type p_exit from w_inherite_standard`p_exit within w_piz2001
integer x = 4416
end type

type p_ins from w_inherite_standard`p_ins within w_piz2001
boolean visible = false
integer x = 3438
integer y = 3624
end type

type p_search from w_inherite_standard`p_search within w_piz2001
boolean visible = false
integer x = 3447
integer y = 3432
end type

type p_addrow from w_inherite_standard`p_addrow within w_piz2001
boolean visible = false
integer x = 3611
integer y = 3624
end type

type p_delrow from w_inherite_standard`p_delrow within w_piz2001
boolean visible = false
integer x = 3785
integer y = 3624
end type

type dw_insert from w_inherite_standard`dw_insert within w_piz2001
boolean visible = false
integer x = 78
integer y = 2644
end type

type st_window from w_inherite_standard`st_window within w_piz2001
boolean visible = false
integer x = 2263
integer y = 3568
integer width = 795
long backcolor = 80269524
end type

type cb_exit from w_inherite_standard`cb_exit within w_piz2001
boolean visible = false
integer x = 3278
integer y = 3420
end type

type cb_update from w_inherite_standard`cb_update within w_piz2001
boolean visible = false
integer x = 2912
integer y = 3424
end type

type cb_insert from w_inherite_standard`cb_insert within w_piz2001
boolean visible = false
integer x = 571
integer y = 2808
end type

type cb_delete from w_inherite_standard`cb_delete within w_piz2001
boolean visible = false
integer x = 1870
integer y = 2576
end type

type cb_retrieve from w_inherite_standard`cb_retrieve within w_piz2001
boolean visible = false
integer x = 9
integer y = 2940
end type

type st_1 from w_inherite_standard`st_1 within w_piz2001
boolean visible = false
integer x = 0
integer y = 3552
long backcolor = 80269524
end type

type cb_cancel from w_inherite_standard`cb_cancel within w_piz2001
boolean visible = false
integer x = 2304
integer y = 2584
end type

type dw_datetime from w_inherite_standard`dw_datetime within w_piz2001
boolean visible = false
integer x = 3058
integer y = 3568
integer width = 745
end type

type sle_msg from w_inherite_standard`sle_msg within w_piz2001
boolean visible = false
integer x = 320
integer y = 3568
integer width = 1902
long backcolor = 80269524
end type

type gb_2 from w_inherite_standard`gb_2 within w_piz2001
boolean visible = false
integer x = 2875
integer y = 3384
integer width = 773
integer height = 160
long backcolor = 80269524
end type

type gb_1 from w_inherite_standard`gb_1 within w_piz2001
boolean visible = false
integer x = 14
integer y = 3372
integer width = 402
integer height = 172
long backcolor = 80269524
end type

type gb_10 from w_inherite_standard`gb_10 within w_piz2001
boolean visible = false
integer y = 3512
integer width = 3808
integer height = 148
long backcolor = 80269524
end type

type dw_list from datawindow within w_piz2001
integer x = 64
integer y = 200
integer width = 4448
integer height = 2020
integer taborder = 10
boolean bringtotop = true
string title = "none"
string dataobject = "d_piz2001_1"
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_1 from datawindow within w_piz2001
boolean visible = false
integer x = 1157
integer y = 2604
integer width = 411
integer height = 188
integer taborder = 20
boolean bringtotop = true
string title = "none"
string dataobject = "d_piz2001_2"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type rr_1 from roundrectangle within w_piz2001
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 59
integer y = 188
integer width = 4466
integer height = 2052
integer cornerheight = 40
integer cornerwidth = 46
end type

