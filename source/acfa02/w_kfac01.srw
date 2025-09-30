$PBExportHeader$w_kfac01.srw
$PBExportComments$년 이월처리
forward
global type w_kfac01 from window
end type
type p_exit from uo_picture within w_kfac01
end type
type p_search from uo_picture within w_kfac01
end type
type st_19 from statictext within w_kfac01
end type
type st_18 from statictext within w_kfac01
end type
type em_year from editmask within w_kfac01
end type
type st_17 from statictext within w_kfac01
end type
type st_16 from statictext within w_kfac01
end type
type st_15 from statictext within w_kfac01
end type
type st_14 from statictext within w_kfac01
end type
type st_13 from statictext within w_kfac01
end type
type st_12 from statictext within w_kfac01
end type
type st_11 from statictext within w_kfac01
end type
type st_10 from statictext within w_kfac01
end type
type st_9 from statictext within w_kfac01
end type
type st_8 from statictext within w_kfac01
end type
type st_7 from statictext within w_kfac01
end type
type st_6 from statictext within w_kfac01
end type
type st_5 from statictext within w_kfac01
end type
type st_4 from statictext within w_kfac01
end type
type rb_2 from radiobutton within w_kfac01
end type
type rb_1 from radiobutton within w_kfac01
end type
type st_3 from statictext within w_kfac01
end type
type cb_exit from commandbutton within w_kfac01
end type
type sle_1 from singlelineedit within w_kfac01
end type
type st_2 from statictext within w_kfac01
end type
type dw_datetime from datawindow within w_kfac01
end type
type st_1 from statictext within w_kfac01
end type
type st_wait from statictext within w_kfac01
end type
type cb_inq from commandbutton within w_kfac01
end type
type gb_5 from groupbox within w_kfac01
end type
type gb_4 from groupbox within w_kfac01
end type
type gb_2 from groupbox within w_kfac01
end type
type gb_1 from groupbox within w_kfac01
end type
type gb_3 from groupbox within w_kfac01
end type
end forward

global type w_kfac01 from window
integer width = 4658
integer height = 2440
boolean titlebar = true
string title = "년이월처리 "
string menuname = "m_shortcut"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 32106727
p_exit p_exit
p_search p_search
st_19 st_19
st_18 st_18
em_year em_year
st_17 st_17
st_16 st_16
st_15 st_15
st_14 st_14
st_13 st_13
st_12 st_12
st_11 st_11
st_10 st_10
st_9 st_9
st_8 st_8
st_7 st_7
st_6 st_6
st_5 st_5
st_4 st_4
rb_2 rb_2
rb_1 rb_1
st_3 st_3
cb_exit cb_exit
sle_1 sle_1
st_2 st_2
dw_datetime dw_datetime
st_1 st_1
st_wait st_wait
cb_inq cb_inq
gb_5 gb_5
gb_4 gb_4
gb_2 gb_2
gb_1 gb_1
gb_3 gb_3
end type
global w_kfac01 w_kfac01

type variables
Boolean ib_any_typing     
String	is_window_id
String     is_today              //시작일자
String     is_totime             //시작시간
String     sModStatus
String     is_usegub           //이력관리 여부
end variables

forward prototypes
public function integer wf_iwol_cancel (string snextyear)
public function integer wf_iwol (string sbaseyear)
end prototypes

public function integer wf_iwol_cancel (string snextyear);String    sKfCod1,sCurrKfCod1,sKfChGb,sKfYear,sBaseYear,sKfEndYy,sKfEndGb,sKfHalf,sKfAqdt
Double    lKFcod2
Decimal   dKfAmt, dKfDeAmt,dNumber1
Integer   iKfJyr,iRowCount

setpointer(hourglass!)

sBaseYear  = STRING(Long(sNextYear) - 1 , '0000') 

st_wait.Visible = TRUE

DECLARE C_KFA02OM0_HIST CURSOR FOR  
	select kfcod1,		kfcod2,	kfaqdt,		kfchgb,	 kfjyr,	 kfendyy,		kfendgb,		nvl(kfamt,0),	nvl(kfdeamt,0),	kfhalf, nvl(number1,0)
		from kfa02om0_hist		where kfyear = :sBaseYear  ;

OPEN  C_KFA02OM0_HIST ;

iRowCount = 0
sCurrKfCod1 = ' '

Do While True
	Fetch C_KFA02OM0_HIST Into :sKfCod1,	:lKfCod2,	:sKfAqdt,	:sKfChGb,	:iKfJyr,	:sKfEndYy,	:sKfEndGb,	:dKfAmt,	:dKfDeAmt,	:sKfHalf, :dNumber1 ;
	IF SQLCA.SQLCODE <> 0 THEN EXIT
	
	IF sCurrKfCod1 <> sKfCod1 then
		sCurrKfCod1 = sKfCod1
		
		st_wait.text = '현재 ' + F_Get_Refferance('F1',sCurrKfCod1)  + '에 대해 이월취소를 하고있습니다.'
	end if
		
	iRowCount = iRowCount + 1

	if Mid(sKfAqdt,1,4) <> sNextYear then
		delete from kfa04om0 where kfyear = :sNextYear and kfcod1 = :sKfCod1 and kfcod2 = :lKfCod2 ;		/*잔고 삭제*/

		update kfa02om0
			set kfchgb = :sKfChGb,	kfjyr = :iKfJyr,			kfendyy = :sKfEndYy,		kfendgb = :sKfEndGb,
				 kfamt  = :dKfAmt,	kfdeamt = :dKfDeAmt,		kfhalf = :sKfHalf,		number1 = :dNumber1
			where kfcod1 = :sKfCod1 and kfcod2 = :lKfCod2 ;
	end if
Loop
Close C_KFA02OM0_HIST;

if iRowCount  = 0 then
   Messagebox("확 인","처리할 자료가 없습니다. !")
	st_wait.text = ''
   return -1
else
	UPDATE "KFA07OM0"  SET "KFYEAR" = :sBaseYear  ;
	
	delete from kfa02om0_hist where kfyear = :sBaseYear ;

	st_wait.text = '처리 완료하였습니다...'

end if

Return 1
end function

public function integer wf_iwol (string sbaseyear);String    sKfCod1,sCurrKfCod1,sKfChGb,sKfDegb,sKfLag,sKfYear,sGiJunDate,sNextYear,sKfAqdt,sKfGubun3,sKfEndYy,sKfEndGb
Double    lKFcod2
Decimal   dKfAmt, dKfDeAmt, dDrAmt[12], dCrAmt[12], dDeAmt[12], dDnAmt[12], &
          dKdepVal, dKdiffVal, dKfJan01, dKfJan02, dKfJan03, dKfJan04, dKfJan05,dPkfAmt =0,dKfAmtBef
Integer   k, iKfJyr,iRowCount

setpointer(hourglass!)

select nvl(kfyear,'0000')	into :sKfYear from kfa07om0;

sGiJunDate = sBaseYear + '1231'
sNextYear  = STRING(Long(sBaseYear) + 1 , '0000') 

ST_WAIT.VISIBLE = TRUE

ST_WAIT.text = '현재 ' + sNextYear + ' 년도 잔고파일을 삭제하고 있습니다...'
DELETE FROM "KFA04OM0"  
	WHERE "KFYEAR" = :sNextYear AND
			"KFCOD1"||"KFCOD2" IN (SELECT "KFCOD1"||"KFCOD2"  FROM "KFA04OM0" WHERE "KFYEAR" = :sBaseYear);

/*고정자산 HIST에 년이월처리 이전 자료를 보관한다.*/
ST_WAIT.text = '현재 ' + sBaseYear + ' 년도 이력을 생성하고 있습니다...'
DELETE FROM "KFA02OM0_HIST"  WHERE "KFA02OM0_HIST"."KFYEAR" = :sBaseYear;
Commit;

INSERT INTO "KFA02OM0_HIST"  
	( "KFYEAR",			"KFCOD1",           "KFCOD2",              "KFSACOD",             "KFJOG",               "KFNAME",   
     "KFNYR",        "KFJYR",            "KFQNTY",   	          "KFBAEG",   	         "KFMDPT",              "KFDECP",   
     "KFDEGB",       "KFCHGB",           "KFSIZE",              "KFMEKR",              "KFAQDT",              "KFAMT",   
     "KFDEAMT",      "KFDODT",           "KFENDGB",             "KFENDYY",             "KFGUBUN",             "KFHALF",   
     "KFGBN",        "WKCTR",            "MANDEPT",             "GUBUN1",              "GUBUN2",              "NUMBER1",   
     "NUMBER2",      "GUBUN3",           "GUBUN4",              "GUBUN5",              "GUBUN6",              "KFFRAMT",
	  "PKFAMT")  
SELECT :sBaseYear,   "KFCOD1",			  "KFCOD2",              "KFSACOD",             "KFJOG",   				  "KFNAME",
     "KFNYR",        "KFJYR",            "KFQNTY",              "KFBAEG",              "KFMDPT",              "KFDECP", 
	  "KFDEGB",       "KFCHGB",           "KFSIZE",              "KFMEKR",              "KFAQDT",              "KFAMT",
	  "KFDEAMT",      "KFDODT",           "KFENDGB",             "KFENDYY",             "KFGUBUN",             "KFHALF",  
	  "KFGBN",        "WKCTR",            "MANDEPT",             "GUBUN1",              "GUBUN2",              "NUMBER1",
	  "NUMBER2",      "GUBUN3",           "GUBUN4",              "GUBUN5",              "GUBUN6",              "KFFRAMT",
	  "PKFAMT"
FROM "KFA02OM0"  ;
IF SQLCA.SQLCODE <> 0 THEN
	F_MessageChk(13,'[고정자산마스타 이력]')
	Return -1
END IF
Commit;

DECLARE C_KFA02OM0 CURSOR FOR  
 SELECT "KFA02OM0"."KFCOD1",            "KFA02OM0"."KFCOD2",            "KFA02OM0"."KFCHGB",
         "KFA02OM0"."KFDEGB",		         "KFA02OM0"."KFAQDT",            "KFA02OM0"."KFJYR",      "KFA02OM0"."GUBUN3",
			"KFA02OM0"."KFENDGB",				"KFA02OM0"."KFENDYY",			  "KFA02OM0"."PKFAMT"
   FROM "KFA02OM0"  
   WHERE ( ( "KFA02OM0"."KFAQDT" <= :sGiJunDate ) AND  "KFA02OM0"."GUBUN3" = '1' AND 
                ( "KFA02OM0"."KFCHGB" <> 'H' )  AND ( "KFA02OM0"."KFCHGB" <> 'I' )  AND ( "KFA02OM0"."KFCHGB" <> 'J' ) ) or
			 ( "KFA02OM0"."GUBUN3" = '2' and NVL("KFA02OM0"."KFENDGB",'N') = 'N' )
ORDER BY "KFA02OM0"."KFCOD1" ASC ;

OPEN  C_KFA02OM0 ;
FETCH C_KFA02OM0 INTO :sKfCod1, :lKFcod2, :sKfChGb, :sKfDegb, :sKfAqdt, :iKfJyr, :sKfGubun3,
							 :sKfEndGb,:sKfEndYy,:dPkfAmt;

iRowCount = 0
sCurrKfCod1 = ' '

DO WHILE SQLCA.SQLCODE = 0
   if sCurrKfCod1 <> sKfCod1 then
      sCurrKfCod1 = sKfCod1      

      ST_WAIT.text = '현재 ' + F_Get_Refferance('F1',sCurrKfCod1)  + '에 대해 이월처리를 하고있습니다.'
   end if

   iRowCount += 1
	
	SELECT "KFA04OM0"."KFAMT",   			"KFA04OM0"."KFDEAMT",  			"KFA04OM0"."KFDR01",   			"KFA04OM0"."KFDR02",   
			"KFA04OM0"."KFDR03",   			"KFA04OM0"."KFDR04",   			"KFA04OM0"."KFDR05",   			"KFA04OM0"."KFDR06",   
			"KFA04OM0"."KFDR07",   			"KFA04OM0"."KFDR08",   			"KFA04OM0"."KFDR09",   			"KFA04OM0"."KFDR10",   
			"KFA04OM0"."KFDR11",   			"KFA04OM0"."KFDR12",  			"KFA04OM0"."KFCR01",   			"KFA04OM0"."KFCR02",   
			"KFA04OM0"."KFCR03",   			"KFA04OM0"."KFCR04",   			"KFA04OM0"."KFCR05",   			"KFA04OM0"."KFCR06",   
			"KFA04OM0"."KFCR07",   			"KFA04OM0"."KFCR08",   			"KFA04OM0"."KFCR09",   			"KFA04OM0"."KFCR10",   
			"KFA04OM0"."KFCR11",   			"KFA04OM0"."KFCR12",   			"KFA04OM0"."KFDE01",   			"KFA04OM0"."KFDE02",   
			"KFA04OM0"."KFDE03",   			"KFA04OM0"."KFDE04",   			"KFA04OM0"."KFDE05",   			"KFA04OM0"."KFDE06",   
			"KFA04OM0"."KFDE07",   			"KFA04OM0"."KFDE08",   			"KFA04OM0"."KFDE09",   			"KFA04OM0"."KFDE10",   
			"KFA04OM0"."KFDE11",   			"KFA04OM0"."KFDE12",				"KFA04OM0"."KFDN01",   			"KFA04OM0"."KFDN02",   
			"KFA04OM0"."KFDN03",   			"KFA04OM0"."KFDN04",   			"KFA04OM0"."KFDN05",   			"KFA04OM0"."KFDN06",   
			"KFA04OM0"."KFDN07",   			"KFA04OM0"."KFDN08",   			"KFA04OM0"."KFDN09",   			"KFA04OM0"."KFDN10",   
			"KFA04OM0"."KFDN11",   			"KFA04OM0"."KFDN12",				"KFA04OM0"."KDEPVAL",			"KFA04OM0"."KDIFFVAL",
			"KFA04OM0"."KFJAN01",			"KFA04OM0"."KFJAN02",			"KFA04OM0"."KFJAN03",			"KFA04OM0"."KFJAN04",
			"KFA04OM0"."KFJAN05"
	INTO :dKfAmt,   							:dKfDeAmt,   						:dDrAmt[1],   						:dDrAmt[2],   
			:dDrAmt[3],   						:dDrAmt[4],   						:dDrAmt[5],   						:dDrAmt[6],   
			:dDrAmt[7],   						:dDrAmt[8],   						:dDrAmt[9],   						:dDrAmt[10],   
			:dDrAmt[11],   						:dDrAmt[12],  						:dCrAmt[1],   						:dCrAmt[2],   
			:dCrAmt[3],   						:dCrAmt[4],   						:dCrAmt[5],   						:dCrAmt[6],   
			:dCrAmt[7],   						:dCrAmt[8],   						:dCrAmt[9],   						:dCrAmt[10],   
			:dCrAmt[11],   						:dCrAmt[12],  						:dDeAmt[1],   						:dDeAmt[2],   
			:dDeAmt[3],   						:dDeAmt[4],   						:dDeAmt[5],   						:dDeAmt[6],   
			:dDeAmt[7],   						:dDeAmt[8],   						:dDeAmt[9],   						:dDeAmt[10],   
			:dDeAmt[11],   						:dDeAmt[12],							:dDnAmt[1],   						:dDnAmt[2],   
			:dDnAmt[3],   						:dDnAmt[4],   						:dDnAmt[5],   						:dDnAmt[6],   
			:dDnAmt[7],   						:dDnAmt[8],   						:dDnAmt[9],   						:dDnAmt[10],   
			:dDnAmt[11],   						:dDnAmt[12],							:dKdepVal,							:dKdiffVal,
			:dKfJan01,							:dKfJan02,							:dKfJan03,							:dKfJan04,
			:dKfJan05
	FROM "KFA04OM0"  
	WHERE ("KFA04OM0"."KFYEAR" = :sBaseYear) AND ("KFA04OM0"."KFCOD1" = :sKfCod1) AND  ( "KFA04OM0"."KFCOD2" = :lKFcod2 );

	 IF SQLCA.SQLCODE = 0 then
		
		FOR k = 1  TO 12
			dKfAmt   += dDrAmt[k] - dCrAmt[k]
			dKfDeAmt += dDeAmt[k] - dDnAmt[k]
			
			dKfAmtBef += dDrAmt[k] - dCrAmt[k]
		NEXT  
		IF sKfGubun3 = '2' THEN  /*무형자산-취득가액에서 당기상각비를 차감후 재설정함*/
			dKfAmt = dKfAmt - dKfDeAmt
			dKfDeAmt = 0
		END IF
  
		IF dKdiffVal <> 0 THEN  //상각부인액이 있을경우 처리//
			dKfJan01 = dKdiffVal + dKfJan01     //전기부인액+당기부인액=>차기 전기상각부인액//
		END IF
  
		IF dKfJan03 <> 0 THEN  //시인부족액중 전기손금추인액이 있을경우 처리//
			dKfJan01 = dKfJan01 - dKfJan03     //전기부인액-당기추인액=>전기상각부인액//
		END IF
		  
		sKfLag = 'Y'
		If dKfAmt - dKfDeAmt > 0 then
			sKfLag = 'N'			 
			INSERT INTO "KFA04OM0"  
				( "KFYEAR",              "KFCOD1",              "KFCOD2",              "KFAMT",              "KFDEAMT",   
				  "KFDR01",              "KFDR02",              "KFDR03",              "KFDR04",             "KFDR05",   
				  "KFDR06",              "KFDR07",              "KFDR08",              "KFDR09",             "KFDR10",   
				  "KFDR11",              "KFDR12",              "KFCR01",              "KFCR02",             "KFCR03",   
				  "KFCR04",              "KFCR05",              "KFCR06",              "KFCR07",             "KFCR08",   
				  "KFCR09",              "KFCR10",              "KFCR11",              "KFCR12",             "KFDE01",   
				  "KFDE02",              "KFDE03",              "KFDE04",              "KFDE05",             "KFDE06",   
				  "KFDE07",   	          "KFDE08",              "KFDE09",              "KFDE10",             "KFDE11",   
				  "KFDE12",              "KFDEDT",         		"KFDN01",              "KFDN02",             "KFDN03",   
				  "KFDN04",              "KFDN05",              "KFDN06",              "KFDN07",             "KFDN08",   
				  "KFDN09",              "KFDN10",              "KFDN11",              "KFDN12",				   "KDEPVAL",
				  "KDIFFVAL",			    "KFJAN01",				   "KFJAN02",				  "KFJAN03",				"KFJAN04",  "KFJAN05",
				  "PKFAMT",					 "BKFAMT")  
			VALUES ( :sNextYear,           :sKfCod1,              :lKFcod2,              :dKfAmt,              :dKfDeAmt,   
					  0,   					  0,   						  0,   					  0,   						  0,   
					  0,   					  0,   						  0,   					  0,   						  0,   
					  0,   					  0,   						  0,   					  0,   						  0,   
					  0,   		           0,   			           0,   		           0,   			           0,   
					  0,  		           0,   						  0,   					  0,   						  0,   
					  0,   					  0,   						  0,   					  0,   						  0,   
					  0,   					  0,   						  0,   					  0,   						  0,   
					  0,   					  '',				           0,   		           0,   			           0,   
					  0,   					  0,   						  0,   					  0,   						  0,   
					  0,   					  0,   						  0,   					  0,							  0,
					  0,						  :dKfJan01,				  0,						  0,							  0,		  0,
					  :dPkfAmt,				  0)  ;
			if SQLCA.SQLCODE <> 0 then
				ST_WAIT.text ='고정자산코드 : ' + sKfCod1 + '-' + STRING(lKFcod2,'######')  +'~n'+ & 
								  '잔고 생성 실패!!'+sqlca.sqlerrtext
				Return -1
			end if           
		end if	
		IF sKfDegb = '1' THEN iKfJyr -= 1
		IF iKfJyr  < 0   THEN iKfJyr = 0 
		IF sKfChGb = 'A' OR sKfChGb = 'B' OR sKfChGb = 'K' THEN
			IF sKfChGb = 'A' THEN sKfChGb = 'B'
			IF sKfLag  = 'Y' THEN sKfChGb = 'K'
			IF sKfLag  = 'Y' THEN iKfJyr  = 0
			if sKfGubun3 = '1' AND dKfDeAmt <= 1000 then  /*상각완료년도, 완료구분 갱신*/
				sKfEndGb = 'Y'
				sKfEndYy = sKfYear
			end if
			if sKfGubun3 = '2' AND dKfAmt = 0 then  /*상각완료년도, 완료구분 갱신*/
				sKfEndGb = 'Y'
				sKfEndYy = sKfYear
			end if  
			 UPDATE "KFA02OM0"  
			 SET "KFCHGB"   = :sKfChGb,   
				  "KFJYR"    = :iKfJyr,
				  "KFENDYY"  = :sKfEndYy,
				  "KFENDGB"  = :sKfEndGb,
				  "KFAMT"    = :dKfAmt,
				  "KFDEAMT"  = :dKfDeAmt,
				  "KFHALF"   = '0'
			 WHERE ( "KFA02OM0"."KFCOD1" = :sKfCod1 ) AND ( "KFA02OM0"."KFCOD2" = :lKFcod2 )   ;
		END IF   
   ELSE
		 ST_WAIT.text ='자산코드 : ' + sKfCod1 + '-' + STRING(lKFcod2,'########')  +'~n'+ '잔고 자료가 존재하지 않습니다...'
							
  END IF
  
   FETCH C_KFA02OM0 INTO :sKfCod1, :lKFcod2, :sKfChGb, :sKfDegb, :sKfAqdt, :iKfJyr, :sKfGubun3, :sKfEndGb,:sKfEndYy,:dPkfAmt;   
LOOP

CLOSE C_KFA02OM0  ;
setpointer(ARROW!)

if iRowCount  = 0 then
   Messagebox("확 인","처리할 자료가 없습니다. !")
   return -1
else
	UPDATE "KFA07OM0"  
   	SET "KFYEAR" = :sNextYear  ;

   ST_WAIT.text = ' ' + sBaseYear + ' 년도 ' + string(iRowCount,'######') + &
                  ' 건 이월처리가 완료되었습니다.'
end if

Return 1
end function

event open;ListviewItem		lvi_Current
lvi_Current.Data = Upper(This.ClassName())
lvi_Current.Label = Trim(This.Title)
lvi_Current.PictureIndex = 1

w_mdi_frame.lv_open_menu.additem(lvi_Current)

is_window_id = this.ClassName()
is_today = f_today()
is_totime = f_totime()
w_mdi_frame.st_window.Text = Upper(is_window_id)

SELECT "SUB2_T"."OPEN_HISTORY"  
  INTO :is_usegub 
  FROM "SUB2_T"  
 WHERE "SUB2_T"."WINDOW_NAME" = :is_window_id   ;

IF is_usegub = 'Y' THEN
   INSERT INTO "PGM_HISTORY"  
	 		 ( "L_USERID",   "CDATE",       "STIME",      "WINDOW_NAME",   "EDATE",   
			   "ETIME",      "IPADD",       "USER_NAME" )  
   VALUES ( :gs_userid,   :is_today,     :is_totime,   :is_window_id,   NULL, 
	   		NULL,         :gs_ipaddress, :gs_comname )  ;

   IF SQLCA.SQLCODE = 0 THEN 
	   COMMIT;
   ELSE 	  
	   ROLLBACK;
   END IF	  
END IF

dw_datetime.InsertRow(0)

STRING DKFYEAR

SELECT "KFA07OM0"."KFYEAR"  
  INTO :DKFYEAR  
  FROM "KFA07OM0"  ;

em_year.TEXT = DKFYEAR

end event

on w_kfac01.create
if this.MenuName = "m_shortcut" then this.MenuID = create m_shortcut
this.p_exit=create p_exit
this.p_search=create p_search
this.st_19=create st_19
this.st_18=create st_18
this.em_year=create em_year
this.st_17=create st_17
this.st_16=create st_16
this.st_15=create st_15
this.st_14=create st_14
this.st_13=create st_13
this.st_12=create st_12
this.st_11=create st_11
this.st_10=create st_10
this.st_9=create st_9
this.st_8=create st_8
this.st_7=create st_7
this.st_6=create st_6
this.st_5=create st_5
this.st_4=create st_4
this.rb_2=create rb_2
this.rb_1=create rb_1
this.st_3=create st_3
this.cb_exit=create cb_exit
this.sle_1=create sle_1
this.st_2=create st_2
this.dw_datetime=create dw_datetime
this.st_1=create st_1
this.st_wait=create st_wait
this.cb_inq=create cb_inq
this.gb_5=create gb_5
this.gb_4=create gb_4
this.gb_2=create gb_2
this.gb_1=create gb_1
this.gb_3=create gb_3
this.Control[]={this.p_exit,&
this.p_search,&
this.st_19,&
this.st_18,&
this.em_year,&
this.st_17,&
this.st_16,&
this.st_15,&
this.st_14,&
this.st_13,&
this.st_12,&
this.st_11,&
this.st_10,&
this.st_9,&
this.st_8,&
this.st_7,&
this.st_6,&
this.st_5,&
this.st_4,&
this.rb_2,&
this.rb_1,&
this.st_3,&
this.cb_exit,&
this.sle_1,&
this.st_2,&
this.dw_datetime,&
this.st_1,&
this.st_wait,&
this.cb_inq,&
this.gb_5,&
this.gb_4,&
this.gb_2,&
this.gb_1,&
this.gb_3}
end on

on w_kfac01.destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.p_exit)
destroy(this.p_search)
destroy(this.st_19)
destroy(this.st_18)
destroy(this.em_year)
destroy(this.st_17)
destroy(this.st_16)
destroy(this.st_15)
destroy(this.st_14)
destroy(this.st_13)
destroy(this.st_12)
destroy(this.st_11)
destroy(this.st_10)
destroy(this.st_9)
destroy(this.st_8)
destroy(this.st_7)
destroy(this.st_6)
destroy(this.st_5)
destroy(this.st_4)
destroy(this.rb_2)
destroy(this.rb_1)
destroy(this.st_3)
destroy(this.cb_exit)
destroy(this.sle_1)
destroy(this.st_2)
destroy(this.dw_datetime)
destroy(this.st_1)
destroy(this.st_wait)
destroy(this.cb_inq)
destroy(this.gb_5)
destroy(this.gb_4)
destroy(this.gb_2)
destroy(this.gb_1)
destroy(this.gb_3)
end on

event closequery;string s_frday, s_frtime

IF is_usegub = 'Y' THEN
	s_frday = f_today()
	
	s_frtime = f_totime()

   UPDATE "PGM_HISTORY"  
      SET "EDATE" = :s_frday,   
          "ETIME" = :s_frtime  
    WHERE ( "PGM_HISTORY"."L_USERID" = :gs_userid ) AND  
          ( "PGM_HISTORY"."CDATE" = :is_today ) AND  
          ( "PGM_HISTORY"."STIME" = :is_totime ) AND  
          ( "PGM_HISTORY"."WINDOW_NAME" = :is_window_id )   ;

	IF SQLCA.SQLCODE = 0 THEN 
	   COMMIT;
   ELSE 	  
	   ROLLBACK;
   END IF	  
END IF	  

long li_index

li_index = w_mdi_frame.lv_open_menu.FindItem(0,This.Title, TRUE,TRUE)

w_mdi_frame.lv_open_menu.DeleteItem(li_index)
w_mdi_frame.st_window.Text = ""
end event

event key;Choose Case key
	Case KeyR!
		p_search.TriggerEvent(Clicked!)
	Case KeyX!
		p_exit.TriggerEvent(Clicked!)
End Choose
end event

event mousemove;if p_exit.PictureName = 'C:\erpman\image\닫기_over.gif' then
	p_exit.PictureName = 'C:\erpman\image\닫기_up.gif'
end If


end event

type p_exit from uo_picture within w_kfac01
integer x = 4443
integer y = 24
integer width = 178
integer taborder = 80
string pointer = "C:\erpman\cur\close.cur"
string picturename = "C:\erpman\image\닫기_up.gif"
end type

event clicked;call super::clicked;w_mdi_frame.sle_msg.text =""
//IF wf_warndataloss("종료") = -1 THEN  	RETURN

close(parent)

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\닫기_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\닫기_up.gif"
end event

type p_search from uo_picture within w_kfac01
integer x = 4265
integer y = 24
integer width = 178
integer taborder = 90
string picturename = "C:\erpman\image\처리_up.gif"
end type

event clicked;call super::clicked;w_mdi_frame.sle_msg.text =""

String  sBaseYear,sFixedYear

sBaseYear = Trim(em_year.Text)
IF sBaseYear = '' OR IsNull(sBaseYear) THEN
	F_MessageChk(1,'[기준년도(회기)]')
	em_year.SetFocus()
	Return
ELSE
	SELECT "KFA07OM0"."KFYEAR"    INTO :sFixedYear    FROM "KFA07OM0"  ;
	if sBaseYear <> sFixedYear Then
		Messagebox("확 인","고정자산 회기년도와 같지 않습니다. !")
		em_year.SetFocus()
		return
	end if
END IF

IF rb_1.Checked = True THEN
	IF Wf_Iwol(sBaseYear) = -1 THEN Return
ELSE
	IF Wf_Iwol_CanCel(sBaseYear) = -1 THEN 
		Rollback;
		Return	
	END IF
END IF
Commit;

end event

event ue_lbuttondown;PictureName = "C:\erpman\image\처리_dn.gif"
end event

event ue_lbuttonup;PictureName = "C:\erpman\image\처리_up.gif"
end event

type st_19 from statictext within w_kfac01
integer x = 791
integer y = 780
integer width = 2537
integer height = 76
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
boolean enabled = false
string text = "* 이월 취소 : 기준년도로 이월된 자료를 이전년도로 이월 취소 처리한다."
boolean focusrectangle = false
end type

type st_18 from statictext within w_kfac01
integer x = 791
integer y = 724
integer width = 1769
integer height = 76
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
boolean enabled = false
string text = "* 이월 처리 : 기준년도의 다음년도로 이월 처리한다."
boolean focusrectangle = false
end type

type em_year from editmask within w_kfac01
integer x = 2153
integer y = 592
integer width = 375
integer height = 92
integer taborder = 10
integer textsize = -11
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 16777215
alignment alignment = center!
string mask = "####"
end type

type st_17 from statictext within w_kfac01
integer x = 1477
integer y = 1792
integer width = 1851
integer height = 76
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
boolean enabled = false
string text = "이월 취소 -> 미상각잔액이 1000보다 크면 상각구분 = ~'~',상각년도 = ~'~'"
boolean focusrectangle = false
end type

type st_16 from statictext within w_kfac01
integer x = 873
integer y = 1728
integer width = 2894
integer height = 76
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
boolean enabled = false
string text = "- 상각구분,상각년도 : 이월 처리 -> 미상각잔액이 1000보다 작으면 상각구분 =~'상각완료~',상각년도=~'기준년도~'"
boolean focusrectangle = false
end type

type st_15 from statictext within w_kfac01
integer x = 2423
integer y = 1636
integer width = 1001
integer height = 76
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
boolean enabled = false
string text = "이월 취소 -> 잔존년수 = 잔존년수 + 1"
boolean focusrectangle = false
end type

type st_14 from statictext within w_kfac01
integer x = 873
integer y = 1636
integer width = 1522
integer height = 76
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
boolean enabled = false
string text = "- 잔존년수 :       이월 처리 -> 잔존년수 = 잔존년수 - 1"
boolean focusrectangle = false
end type

type st_13 from statictext within w_kfac01
integer x = 1390
integer y = 1572
integer width = 2039
integer height = 76
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
boolean enabled = false
string text = "이월 취소 -> 과년도취득 => 신규취득(과년도취득중 취득년도 = 기준년도)"
boolean focusrectangle = false
end type

type st_12 from statictext within w_kfac01
integer x = 873
integer y = 1508
integer width = 1522
integer height = 76
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
boolean enabled = false
string text = "- 변동구분 :       이월 처리 -> 신규취득 => 과년도취득 "
boolean focusrectangle = false
end type

type st_11 from statictext within w_kfac01
integer x = 1390
integer y = 1444
integer width = 1522
integer height = 76
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
boolean enabled = false
string text = "이월 취소 -> 기초상각누계액 - 당기상각액 + 충당금감소액"
boolean focusrectangle = false
end type

type st_10 from statictext within w_kfac01
integer x = 873
integer y = 1380
integer width = 2043
integer height = 76
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
boolean enabled = false
string text = "- 기초상각누계액 : 이월 처리 -> 기초상각누계액 + 당기상각액 - 충당금감소액"
boolean focusrectangle = false
end type

type st_9 from statictext within w_kfac01
integer x = 1394
integer y = 1316
integer width = 1413
integer height = 76
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
boolean enabled = false
string text = "이월 취소 -> 기초취득가액 - 당기증가액 + 당기감소액"
boolean focusrectangle = false
end type

type st_8 from statictext within w_kfac01
integer x = 873
integer y = 1080
integer width = 2647
integer height = 76
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
boolean enabled = false
string text = "- 이월 취소 : 기준년도의 다음년도(회기)로 생성한 자료를 삭제한다."
boolean focusrectangle = false
end type

type st_7 from statictext within w_kfac01
integer x = 873
integer y = 1252
integer width = 1934
integer height = 76
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
boolean enabled = false
string text = "- 기초취득가액 :   이월 처리 -> 기초취득가액 + 당기증가액 - 당기감소액"
boolean focusrectangle = false
end type

type st_6 from statictext within w_kfac01
integer x = 873
integer y = 1016
integer width = 2647
integer height = 76
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
boolean enabled = false
string text = "- 이월 처리 : 12월까지 감가상각 계산 완료 후 해당 자산들을 기준년도의 다음년도(회기)로 생성한다."
boolean focusrectangle = false
end type

type st_5 from statictext within w_kfac01
integer x = 795
integer y = 1188
integer width = 2784
integer height = 76
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
boolean enabled = false
string text = "2. 고정자산 마스타"
boolean focusrectangle = false
end type

type st_4 from statictext within w_kfac01
integer x = 795
integer y = 952
integer width = 2784
integer height = 76
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
boolean enabled = false
string text = "1. 고정잔산 잔고"
boolean focusrectangle = false
end type

type rb_2 from radiobutton within w_kfac01
integer x = 3415
integer y = 152
integer width = 329
integer height = 76
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "이월 취소"
end type

type rb_1 from radiobutton within w_kfac01
integer x = 3415
integer y = 76
integer width = 329
integer height = 76
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "이월 처리"
boolean checked = true
end type

type st_3 from statictext within w_kfac01
integer x = 923
integer y = 464
integer width = 2619
integer height = 100
integer textsize = -13
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 65535
long backcolor = 8421504
boolean enabled = false
string text = "고정자산을 읽어서 다음년도(회기)로 이월 처리/취소 합니다"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_exit from commandbutton within w_kfac01
boolean visible = false
integer x = 3150
integer y = 2396
integer width = 329
integer height = 108
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "종료(&X)"
end type

event clicked;close(parent)
end event

type sle_1 from singlelineedit within w_kfac01
boolean visible = false
integer x = 334
integer y = 2744
integer width = 2501
integer height = 84
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 12632256
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

type st_2 from statictext within w_kfac01
boolean visible = false
integer x = 23
integer y = 2744
integer width = 315
integer height = 84
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 12632256
boolean enabled = false
string text = "메세지"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type dw_datetime from datawindow within w_kfac01
boolean visible = false
integer x = 2834
integer y = 2740
integer width = 759
integer height = 92
string dataobject = "d_datetime"
boolean border = false
boolean livescroll = true
end type

type st_1 from statictext within w_kfac01
integer x = 1632
integer y = 612
integer width = 521
integer height = 72
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
boolean enabled = false
string text = "기준년도(회기)"
alignment alignment = center!
long bordercolor = 16711935
boolean focusrectangle = false
end type

type st_wait from statictext within w_kfac01
boolean visible = false
integer x = 759
integer y = 2072
integer width = 2610
integer height = 128
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "돋움체"
boolean italic = true
long textcolor = 65535
long backcolor = 8421504
boolean enabled = false
alignment alignment = center!
boolean border = true
long bordercolor = 255
boolean focusrectangle = false
end type

type cb_inq from commandbutton within w_kfac01
boolean visible = false
integer x = 2789
integer y = 2396
integer width = 329
integer height = 108
integer taborder = 20
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "처리(&P)"
end type

event clicked;String  sBaseYear,sFixedYear

sBaseYear = Trim(em_year.Text)
IF sBaseYear = '' OR IsNull(sBaseYear) THEN
	F_MessageChk(1,'[기준년도(회기)]')
	em_year.SetFocus()
	Return
ELSE
	SELECT "KFA07OM0"."KFYEAR"    INTO :sFixedYear    FROM "KFA07OM0"  ;
	if sBaseYear <> sFixedYear Then
		Messagebox("확 인","고정자산 회기년도와 같지 않습니다. !")
		em_year.SetFocus()
		return
	end if
END IF

IF rb_1.Checked = True THEN
	IF Wf_Iwol(sBaseYear) = -1 THEN Return
ELSE
	IF Wf_Iwol_CanCel(sBaseYear) = -1 THEN 
		Rollback;
		Return	
	END IF
END IF
Commit;

end event

type gb_5 from groupbox within w_kfac01
integer x = 672
integer y = 868
integer width = 3154
integer height = 1060
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
end type

type gb_4 from groupbox within w_kfac01
boolean visible = false
integer x = 2752
integer y = 2348
integer width = 768
integer height = 176
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
end type

type gb_2 from groupbox within w_kfac01
integer x = 3342
integer y = 28
integer width = 494
integer height = 224
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
end type

type gb_1 from groupbox within w_kfac01
boolean visible = false
integer y = 2700
integer width = 3598
integer height = 140
integer taborder = 40
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 12632256
end type

type gb_3 from groupbox within w_kfac01
integer x = 672
integer y = 496
integer width = 3154
integer height = 372
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
end type

