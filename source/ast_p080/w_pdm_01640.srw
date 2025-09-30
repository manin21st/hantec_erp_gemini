$PBExportHeader$w_pdm_01640.srw
$PBExportComments$표준원가계산창
forward
global type w_pdm_01640 from window
end type
type pb_1 from u_pb_cal within w_pdm_01640
end type
type p_exit from uo_picture within w_pdm_01640
end type
type p_3 from uo_picture within w_pdm_01640
end type
type p_2 from uo_picture within w_pdm_01640
end type
type p_1 from uo_picture within w_pdm_01640
end type
type rb_4 from radiobutton within w_pdm_01640
end type
type rb_3 from radiobutton within w_pdm_01640
end type
type rb_2 from radiobutton within w_pdm_01640
end type
type rb_1 from radiobutton within w_pdm_01640
end type
type st_msg from statictext within w_pdm_01640
end type
type st_4 from statictext within w_pdm_01640
end type
type st_3 from statictext within w_pdm_01640
end type
type st_2 from statictext within w_pdm_01640
end type
type st_1 from statictext within w_pdm_01640
end type
type dw_1 from datawindow within w_pdm_01640
end type
type cb_2 from commandbutton within w_pdm_01640
end type
type rr_1 from roundrectangle within w_pdm_01640
end type
type rr_2 from roundrectangle within w_pdm_01640
end type
type rr_3 from roundrectangle within w_pdm_01640
end type
end forward

global type w_pdm_01640 from window
integer width = 4658
integer height = 2440
boolean titlebar = true
string title = "표준원가계산"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 32106727
pb_1 pb_1
p_exit p_exit
p_3 p_3
p_2 p_2
p_1 p_1
rb_4 rb_4
rb_3 rb_3
rb_2 rb_2
rb_1 rb_1
st_msg st_msg
st_4 st_4
st_3 st_3
st_2 st_2
st_1 st_1
dw_1 dw_1
cb_2 cb_2
rr_1 rr_1
rr_2 rr_2
rr_3 rr_3
end type
global w_pdm_01640 w_pdm_01640

type variables
 DECLARE Cur_sltcd_Y CURSOR FOR  
  SELECT "DANMST"."STDRATE",   
         "DANMST"."UNPRC"  
    FROM "DANMST",   
         "ITEMAS",   
         "ROUTNG"  
   WHERE ( "DANMST"."ITNBR" = "ITEMAS"."ITNBR" ) and  
         ( "ITEMAS"."ITNBR" = "ROUTNG"."ITNBR" ) and  
         ( "DANMST"."OPSEQ" = "ROUTNG"."OPSEQ" ) and  
         ( ( "DANMST"."SLTCD" = 'Y' ) )   ;
 DECLARE Cur_UNPRC CURSOR FOR  
  SELECT "DANMST"."UNPRC",   
         "DANMST"."STDRATE",   
         "ROUTNG"."PURGC",   
         "ROUTNG"."UNITQ",   
         "ROUTNG"."STDST",   
         "ROUTNG"."STDMC",   
         "ROUTNG"."MANHR",   
         "ROUTNG"."MCHR",   
         "ROUTNG"."TBCQT"  
    FROM "DANMST",   
         "ITEMAS",   
         "ROUTNG"  
   WHERE ( "DANMST"."ITNBR" = "ITEMAS"."ITNBR" ) and  
         ( "ITEMAS"."ITNBR" = "ROUTNG"."ITNBR" ) and  
         ( ( "DANMST"."OPSEQ" = '9999' ) AND  
         ( "DANMST"."SLTCD" = 'Y' ) )   ;
			
String	is_window_id, is_today, is_totime, is_usegub			


end variables

on w_pdm_01640.create
this.pb_1=create pb_1
this.p_exit=create p_exit
this.p_3=create p_3
this.p_2=create p_2
this.p_1=create p_1
this.rb_4=create rb_4
this.rb_3=create rb_3
this.rb_2=create rb_2
this.rb_1=create rb_1
this.st_msg=create st_msg
this.st_4=create st_4
this.st_3=create st_3
this.st_2=create st_2
this.st_1=create st_1
this.dw_1=create dw_1
this.cb_2=create cb_2
this.rr_1=create rr_1
this.rr_2=create rr_2
this.rr_3=create rr_3
this.Control[]={this.pb_1,&
this.p_exit,&
this.p_3,&
this.p_2,&
this.p_1,&
this.rb_4,&
this.rb_3,&
this.rb_2,&
this.rb_1,&
this.st_msg,&
this.st_4,&
this.st_3,&
this.st_2,&
this.st_1,&
this.dw_1,&
this.cb_2,&
this.rr_1,&
this.rr_2,&
this.rr_3}
end on

on w_pdm_01640.destroy
destroy(this.pb_1)
destroy(this.p_exit)
destroy(this.p_3)
destroy(this.p_2)
destroy(this.p_1)
destroy(this.rb_4)
destroy(this.rb_3)
destroy(this.rb_2)
destroy(this.rb_1)
destroy(this.st_msg)
destroy(this.st_4)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.dw_1)
destroy(this.cb_2)
destroy(this.rr_1)
destroy(this.rr_2)
destroy(this.rr_3)
end on

event open;Integer  li_idx

li_idx = w_mdi_frame.dw_listbar.InsertRow(0)
w_mdi_frame.dw_listbar.SetItem(li_idx,'window_id',Upper(This.ClassName()))
w_mdi_frame.dw_listbar.SetItem(li_idx,'window_name',Upper(This.Title))
w_mdi_frame.Postevent("ue_barrefresh")

is_today = f_today()
is_totime = f_totime()
is_window_id = this.ClassName()

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

DW_1.Settransobject(SQLCA)
dw_1.InsertRow(0)

dw_1.SetItem(1, "sle_yymmdd", f_today())
end event

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

w_mdi_frame.st_window.Text = ''

long li_index

li_index = w_mdi_frame.dw_listbar.Find("window_id = '" + Upper(This.ClassName()) + "'", 1, w_mdi_frame.dw_listbar.RowCount())

w_mdi_frame.dw_listbar.DeleteRow(li_index)
w_mdi_frame.Postevent("ue_barrefresh")
end event

type pb_1 from u_pb_cal within w_pdm_01640
integer x = 2729
integer y = 1072
integer taborder = 20
end type

event clicked;call super::clicked;dw_1.SetColumn('sle_yymmdd')
IF Isnull(gs_code) THEN Return
dw_1.SetItem(dw_1.getrow(), 'sle_yymmdd', gs_code)
end event

type p_exit from uo_picture within w_pdm_01640
integer x = 4416
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

type p_3 from uo_picture within w_pdm_01640
integer x = 4114
integer y = 24
integer width = 302
integer taborder = 90
string picturename = "C:\erpman\image\표준원가계산서_up.gif"
end type

event clicked;call super::clicked;Open(W_PDM_11760)
end event

event ue_lbuttondown;p_3.PictureName = "C:\erpman\image\표준원가계산서_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;p_3.PictureName = "C:\erpman\image\표준원가계산서_up.gif"
end event

type p_2 from uo_picture within w_pdm_01640
integer x = 3611
integer y = 24
integer width = 338
integer taborder = 90
string picturename = "C:\erpman\image\임시사전원가계산_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;p_2.PictureName = "C:\erpman\image\임시사전원가계산_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;p_2.pictureName = "C:\erpman\image\임시사전원가계산_up.gif"
end event

event clicked;
string ue_yymm,UE_YYMMDD,ue_sys_date,arg_itnbr,GET_ITNBR,UE_PINBR
string ue_purgc,ue_wkctr,UE_ITTYP,UE_HSNO,UE_OPSEQ,UE_CCODE,UE_CVCOD,UE_CVGU

dec 	level,max_level,row,incre_row = 0
dec	GAN_RATE,TOT_COUNT = 0,CUR_COUNT = 0 // 간접비율
dec  	ue_stdrate,ue_unitq,ue_stdst,ue_stdmc,ue_manhr,ue_mchr,ue_tbcqt
DEC 	jun_time,STAND_TIME,jun_time3,Temp_Unprc = 0,ue_unprc,out_unprc = 0,UE_AMOUNT,UE_CUSRAT,UE_APPRAT, UE_SUM_WON

      DW_1.ACCEPTTEXT()
      UE_YYMMDD = trim(DW_1.GetItemString(1,"sle_yymmdd"))
		GAN_RATE = DW_1.GETITEMDECIMAL(1,"GAN_RATE")
		ue_yymm = MID(UE_YYMMDD,1,6)
	   
		IF ISNULL(GAN_RATE)	THEN GAN_RATE = 0
	////////////////////////////////////////////////////////////////////////////////////		
		// 해당월 초기화
	   DELETE FROM "ITEMCC"  
		   WHERE "YYMM" = :ue_YYMM   ;
			
		DELETE FROM "ITEMCC_SEQ"  
		   WHERE "YYMM" = :ue_YYMM   ;
			
		DELETE FROM "ITEMLV" ;	
			

		
		IF ISNULL(GAN_RATE) THEN GAN_RATE = 0
	   ue_sys_date = STRING(TOday(),"YYYYMMDD")

//---------------------- "ITEMLV" 에 품번과 레벨을 인서트한다------------------------//
SetPointer(HourGlass!)
SELECT COUNT(*)
INTO :TOT_COUNT
FROM ITEMAS ;


w_mdi_frame.sle_msg.text = "사전원가를 계산하고 있습니다...."

DECLARE CUR_ITEMLV CURSOR FOR
        SELECT  "ITNBR", "HSNO", "ITTYP"
			 FROM "ITEMAS" ;


OPEN CUR_ITEMLV ;
DO WHILE TRUE
FETCH CUR_ITEMLV INTO :arg_itnbr,:UE_HSNO,:UE_ITTYP ;


CUR_COUNT ++

IF SQLCA.SQLCODE <> 0 THEN EXIT 


 	          level = low_level_code(arg_itnbr)
             INSERT INTO "ITEMLV"( "ITNBR","POOM_LEVEL" )  /****레벨테이블 작성*****/
                  VALUES ( :arg_itnbr,:level )  ;




/*************************프로시져로 등록 ******************************/  
  SELECT  "ITNBR"  
    INTO :GET_ITNBR
    FROM "ROUTNG"  
   WHERE  "ITNBR" = :ARG_ITNBR   ;


IF SQLCA.SQLCODE = 100		THEN	//단가 프로세스1
//IF GET_ITNBR <> ARG_ITNBR THEN 
	
						
		       DECLARE CUR_DAN_PROCESS1 CURSOR FOR
						        SELECT  "UNPRC", "STDRATE", "CVCOD"
                            FROM "DANMST"  
                           WHERE (  "ITNBR" = :arg_itnbr ) AND  
                                 (  "OPSEQ" = '9999' ) AND  
                                 (  "SLTCD" = 'Y' )   ;
					OPEN CUR_DAN_PROCESS1 ;

					
					DO WHILE TRUE
				   	FETCH CUR_DAN_PROCESS1 INTO :ue_unprc,:UE_STDRATE,:UE_CVCOD ;
						IF SQLCA.SQLCODE <> 0 THEN EXIT     
					       
							 IF ISNULL(ue_unprc) THEN ue_unprc = 0 
					       IF ISNULL(UE_STDRATE) THEN UE_STDRATE = 1
					
					             SELECT "VNDMST"."CVGU"
									   INTO :UE_CVGU
									  FROM "VNDMST"
									  WHERE "VNDMST"."CVCOD" = :UE_CVCOD ;
									 
									 IF UE_CVGU <> '2' THEN
										 out_unprc = ue_unprc
	   							 ELSE //수입

												 UE_CUSRAT = 0
												 UE_APPRAT = 0

										       SELECT "IMPRAT"."CUSRAT","IMPRAT"."APPRAT"  //관세율,수입비용율
                                       INTO :UE_CUSRAT,:UE_APPRAT  
          								      FROM "IMPRAT"  
                                       WHERE "IMPRAT"."HSNO" = SUBSTR(:UE_HSNO,1,4)   ;

										 IF ISNULL(UE_CUSRAT) THEN	UE_CUSRAT = 0
										 IF ISNULL(UE_APPRAT) THEN	UE_APPRAT = 0
										 
										 Temp_Unprc = (ue_unprc * UE_STDRATE) 
										 out_unprc = Temp_Unprc + (Temp_Unprc * (UE_CUSRAT/100)) + (Temp_Unprc * (UE_APPRAT/100))	

									 END IF


									 
					             INSERT INTO "ITEMCC" ( "ITNBR","YYMM","GUBUN","CVCOD","WON_AMT","GIJUN_DATE","SYS_DATE" )  
                            VALUES ( :arg_itnbr,:ue_yymm,'1','000001',:out_unprc,:UE_YYMMDD,:ue_sys_date)  ;				 
									 IF SQLCA.SQLCODE <> 0	THEN
										 MESSAGEBOX("확인",string(sqlca.sqlcode))
										 ROLLBACK;
										 RETURN
									 END IF
									 
									 IF UE_ITTYP = '3' THEN
										 out_unprc = (out_unprc * (GAN_RATE/100))
									    INSERT INTO "ITEMCC" ( "ITNBR","YYMM","GUBUN","CVCOD","WON_AMT","GIJUN_DATE","SYS_DATE" )  
                               VALUES ( :arg_itnbr,:ue_yymm,'1','000002',:out_unprc,:UE_YYMMDD,:ue_sys_date)  ;
   								 END IF
									 
  				   LOOP     
				   CLOSE CUR_DAN_PROCESS1 ;						
	         		
ELSE				//	공정에 품목이 있는경우

 
	
	    DECLARE CUR_ROUTNG_ITNBR CURSOR FOR       
			      SELECT  "PURGC", "UNITQ", "STDST",   
                       "STDMC", "MANHR", "MCHR",   
                       "TBCQT", "WKCTR", "OPSEQ"  
                 FROM "ROUTNG"
  				    WHERE  "ITNBR" = :arg_itnbr ;

				 
   			OPEN CUR_ROUTNG_ITNBR ;
	   		DO WHILE TRUE
		   	FETCH CUR_ROUTNG_ITNBR INTO :UE_PURGC,:UE_UNITQ,:UE_STDST,:UE_STDMC,:UE_MANHR,
		                                  :UE_MCHR,:UE_TBCQT,:UE_WKCTR,:UE_OPSEQ ;
				IF SQLCA.SQLCODE <> 0 THEN EXIT	
							
						
                 
					  IF UE_PURGC = 'Y' THEN   //외주PROCESS
				     
					DECLARE CUR_DAN_PROCESS2 CURSOR FOR 
					      SELECT  "UNPRC", "STDRATE", "CVCOD"  
                       FROM "DANMST"  
                      WHERE (  "ITNBR" = :ARG_ITNBR ) AND  
                            (  "OPSEQ" = :UE_OPSEQ ); 
                           
               OPEN CUR_DAN_PROCESS2 ;
					DO WHILE TRUE
					FETCH CUR_DAN_PROCESS2 INTO :UE_UNPRC,:UE_STDRATE,:UE_CVCOD ;
					
					IF SQLCA.SQLCODE <> 0 THEN EXIT
					IF ISNULL(ue_unprc) THEN ue_unprc = 0 
					       SELECT "CVGU"
									INTO :UE_CVGU
									FROM "VNDMST"
									WHERE "CVCOD" = :UE_CVCOD ;
									 IF UE_CVGU <> '2' THEN
								         out_unprc = ue_unprc
      	   					 ELSE //수입
										
							    SELECT "CUSRAT","APPRAT"  //관세율,수입비용율
                           INTO :UE_CUSRAT,:UE_APPRAT  
          				      FROM "IMPRAT"  
                          WHERE ("HSNO" = SUBSTR(:UE_HSNO,1,4)  OR
								   		"HSNO" = SUBSTR(:UE_HSNO,1,6)  OR
											"HSNO" = SUBSTR(:UE_HSNO,1,8)  OR
											"HSNO" = SUBSTR(:UE_HSNO,1,10) )	AND
											ROWNUM = 1 ;
								  
								 Temp_Unprc = (ue_unprc * UE_STDRATE) 
 								 out_unprc = Temp_Unprc + (Temp_Unprc * (UE_CUSRAT/100)) + (Temp_Unprc * (UE_APPRAT/100))	
							 END IF
					             
							 SELECT  "WON_AMT"
   							INTO :UE_SUM_WON
							   FROM "ITEMCC"
								WHERE "ITNBR" = :ARG_ITNBR AND
								      "YYMM" = :ue_yymm AND
										"GUBUN" = '1' AND
										"CVCOD" = '000003' ;

							// 사전원가코드가 없을 경우 		
							IF IsNull(UE_SUM_WON) 	THEN	UE_SUM_WON  = 0		 
							
							IF UE_SUM_WON = 0 THEN    
								
								IF SQLCA.SQLCODE = 100	THEN
									INSERT INTO "ITEMCC" ( "ITNBR","YYMM","GUBUN","CVCOD","WON_AMT","GIJUN_DATE","SYS_DATE" )  
   	                         VALUES ( :arg_itnbr,:ue_yymm,'1','000003',:out_unprc,:UE_YYMMDD,:ue_sys_date)  ;
								END IF
      
							ELSE
								   out_unprc = out_unprc + UE_SUM_WON
 									UPDATE "ITEMCC"  
                              SET "WON_AMT" = :out_unprc  
	                         WHERE (  "ITNBR" = :ARG_ITNBR ) AND  
                                  (  "YYMM" = :ue_yymm ) AND  
                                  (  "GUBUN" = '1' ) AND  
                                  (  "CVCOD" = '000003' )   ;
          				       				 
							END IF
							
							///////////////////////////////////////////////////////////////////////
							// * 공정별 ITEMCC_SEQ : 외주가공비 입력
							///////////////////////////////////////////////////////////////////////							
							 UE_SUM_WON = 0
							 SELECT "WON_AMT"
   							INTO :UE_SUM_WON
							   FROM "ITEMCC_SEQ"
								WHERE "ITNBR" = :ARG_ITNBR AND
								      "YYMM" = :ue_yymm 	AND
										"OPSEQ" = :UE_OPSEQ	AND
										"GUBUN" = '1' AND
										"CVCOD" = '000003' ;

							// 사전원가코드가 없을 경우 		
							IF IsNull(UE_SUM_WON) 	THEN	UE_SUM_WON  = 0		 
							IF UE_SUM_WON = 0 THEN    
								IF SQLCA.SQLCODE = 100	THEN
									INSERT INTO "ITEMCC_SEQ" ( "ITNBR","YYMM", "OPSEQ","GUBUN","CVCOD","WON_AMT","GIJUN_DATE","SYS_DATE" )  
   	                         VALUES ( :arg_itnbr,:ue_yymm,:UE_OPSEQ,'1','000003',:out_unprc,:UE_YYMMDD,:ue_sys_date)  ;
								END IF
                     ELSE
								   out_unprc = out_unprc + UE_SUM_WON
 									UPDATE "ITEMCC_SEQ"  
                              SET "WON_AMT" = :out_unprc  
	                         WHERE ( "ITNBR" = :ARG_ITNBR ) AND  
                                  ( "YYMM" = :ue_yymm ) AND  
											 (	"OPSEQ" = :UE_OPSEQ	) AND											 
                                  ( "GUBUN" = '1' ) AND  
                                  ( "CVCOD" = '000003' )   ;
          				       				 
							END IF
							
							///////////////////////////////////////////////////////////////////////							
							// * 공정별 ITEMCC_SEQ : 외주가공비 입력 END 
							///////////////////////////////////////////////////////////////////////							
							
							
							
      			LOOP
					CLOSE CUR_DAN_PROCESS2 ;
             
			     ELSE                     //가공PROCESS
					
						if ISNULL(ue_unitq) or ue_unitq = 0 then ue_unitq = 1
							    Jun_time = (ue_stdmc * ue_stdst) / ue_unitq //준비시간
   					if ISNULL(ue_tbcqt) or ue_tbcqt = 0 then ue_tbcqt = 1
							    STAND_TIME = (ue_manhr + ue_mchr) / ue_tbcqt //표준시간
					
					     DECLARE Cur_AMOUNT CURSOR FOR
					           SELECT  "AMOUNT", "CCODE"
								    FROM  "WRKDTL"
								   WHERE  "WKCTR" = :ue_wkctr AND 
											 "CCODE" NOT IN ('000001','000002','000003');

								  OPEN Cur_AMOUNT ;
								  DO WHILE TRUE
								  FETCH Cur_AMOUNT INTO  :UE_AMOUNT,:UE_CCODE ;
								  IF SQLCA.SQLCODE <> 0 THEN EXIT
								  
								  out_unprc = UE_AMOUNT * (Jun_time + STAND_TIME) / 60

								  STRING	sCONFIRM
								  SELECT ITNBR
								    INTO :sCONFIRM
									 FROM ITEMCC
									WHERE YYMM = :ue_yymm	 AND
											ITNBR = :ARG_ITNBR AND
											GUBUN = '1'			 AND
											CVCOD = :UE_CCODE ;
									
									IF SQLCA.SQLCODE = 100	THEN
										
						 			  INSERT INTO "ITEMCC" ( "ITNBR","YYMM","GUBUN","CVCOD","WON_AMT","GIJUN_DATE","SYS_DATE" )  
   	                       VALUES ( :ARG_itnbr,:ue_yymm,'1',:UE_CCODE,:out_unprc,:UE_YYMMDD,:ue_sys_date) ;		

									ELSE
	 									UPDATE "ITEMCC"  
   	                           SET "WON_AMT" = "WON_AMT" + :out_unprc  
	   	                      WHERE (  "ITNBR" = :ARG_ITNBR ) AND  
         	                         (  "YYMM" = :ue_yymm ) AND  
               	                   (  "GUBUN" = '1' ) AND  
                  	                (  "CVCOD" = :UE_CCODE )   ;
										
									END IF

							///////////////////////////////////////////////////////////////////////							
							// * 공정별 ITEMCC_SEQ : 가공비 입력  
							///////////////////////////////////////////////////////////////////////							
								  SELECT ITNBR
								    INTO :sCONFIRM
									 FROM ITEMCC_SEQ
									WHERE YYMM = :ue_yymm	 AND
											ITNBR = :ARG_ITNBR AND
											OPSEQ = :UE_OPSEQ	 AND
											GUBUN = '1'			 AND
											CVCOD = :UE_CCODE ;

									IF SQLCA.SQLCODE = 100	THEN
										
						 			  INSERT INTO "ITEMCC_SEQ" ( "ITNBR","YYMM","OPSEQ","GUBUN","CVCOD","WON_AMT","GIJUN_DATE","SYS_DATE" )  
   	                       VALUES ( :ARG_itnbr,:ue_yymm,:UE_OPSEQ,'1',:UE_CCODE,:out_unprc,:UE_YYMMDD,:ue_sys_date) ;		

									ELSE
	 									UPDATE "ITEMCC_SEQ"  
   	                           SET "WON_AMT" = "WON_AMT" + :out_unprc  
	   	                      WHERE ( "ITNBR" = :ARG_ITNBR ) AND  
         	                         ( "YYMM" = :ue_yymm ) AND  
												 (	"OPSEQ" = :UE_OPSEQ	) AND											 
               	                   ( "GUBUN" = '1' ) AND  
                  	                ( "CVCOD" = :UE_CCODE )   ;
									END IF
							///////////////////////////////////////////////////////////////////////							
							// * 공정별 ITEMCC_SEQ : 가공비 입력  END
							///////////////////////////////////////////////////////////////////////							


							     LOOP
								  CLOSE Cur_AMOUNT ;

   			  END IF	
					  
			
			LOOP			  
			 CLOSE CUR_ROUTNG_ITNBR ;
		END IF		 
LOOP
CLOSE CUR_ITEMLV ;





//--------------공정순으로 제조원가 --------------------------------------------------//							

w_mdi_frame.sle_msg.text = "제조원가를 적상중입니다...."

dec 	GET_LEVEL, CAL_LEVEL,ue_won_amt,set_won_amt, ue_qtypr,TEMP_WON_AMT
INT i
STRING CAL_ITNBR


SELECT MAX( "POOM_LEVEL")
 INTO :GET_LEVEL
 FROM "ITEMLV" ;
 
DO UNTIL GET_LEVEL = -1
	
    
					
       DECLARE Cur_get_level_itnbr CURSOR FOR
	     SELECT  "ITNBR", "POOM_LEVEL"
		    FROM "ITEMLV"
   		WHERE  "POOM_LEVEL" = :GET_LEVEL ;
			
       OPEN Cur_get_level_itnbr ; 
	    DO WHILE TRUE
	    FETCH Cur_get_level_itnbr INTO :CAL_ITNBR , :CAL_LEVEL ;
		       IF SQLCA.SQLCODE <> 0 THEN EXIT
                
					 DECLARE Cur_get_CVCOD CURSOR FOR
				     SELECT distinct  "CVCOD", "WON_AMT"
 					    FROM "ITEMCC"
					   WHERE  "ITNBR" = :CAL_ITNBR AND
						       "YYMM"  = :ue_yymm 	 ;
								
					 OPEN Cur_get_CVCOD ;
					 DO WHILE TRUE
					 FETCH Cur_get_CVCOD INTO :ue_cvcod ,:ue_won_amt ;
					 IF SQLCA.SQLCODE <> 0 THEN EXIT
					      IF ISNULL(ue_won_amt) THEN ue_won_amt = 0 
					      long num_ue_YYMMDD 
							     num_ue_YYMMDD = long(UE_YYMMDD)
								  
							DECLARE Cur_get_QTYPR CURSOR FOR 
							 SELECT DISTINCT  "QTYPR", "PINBR" 
							   FROM "PSTRUC"
							  WHERE  "CINBR" = :CAL_ITNBR AND
							         "EFTDT" >= :num_ue_YYMMDD AND
									   "EFRDT" <= :num_ue_YYMMDD ;
							        
							
							OPEN Cur_get_QTYPR ;
							DO WHILE TRUE
							FETCH Cur_get_QTYPR INTO :ue_QTYPR,:UE_PINBR ;
							IF SQLCA.SQLCODE <> 0 THEN EXIT 
							
							     set_won_amt = 0
								  set_won_amt = (ue_won_amt * ue_QTYPR)
		
							// 하위품번 -> BOM상위품번 검색 : 사전원가 적상
							SELECT  "WON_AMT"
							INTO :TEMP_WON_AMT
							FROM "ITEMCC"
							WHERE  "ITNBR" = :UE_PINBR AND
							       "YYMM" = :UE_YYMM AND
								    "GUBUN" = '2' AND
									 "CVCOD" = :UE_CVCOD ;
							
							IF ISNULL(TEMP_WON_AMT) THEN TEMP_WON_AMT = 0 
							IF SQLCA.SQLCODE = 100	THEN
								INSERT INTO "ITEMCC"( "ITNBR","YYMM","GUBUN","CVCOD","WON_AMT","GIJUN_DATE","SYS_DATE" )  
   	                  VALUES ( :UE_PINBR,:ue_yymm,'2',:ue_cvcod,:set_won_amt,:UE_YYMMDD,:ue_sys_date )  ;
							ELSE
		
								UPDATE ITEMCC
									SET WON_AMT = WON_AMT + :SET_WON_AMT
								 WHERE ITNBR = :UE_PINBR	AND
								 		 YYMM  = :UE_YYMM		AND
										 GUBUN = '2'			AND
										 CVCOD = :UE_CVCOD ;
		
							END IF
		
							LOOP
							CLOSE Cur_get_QTYPR ;
						
					 LOOP		 
					 CLOSE Cur_get_CVCOD ;        
		 LOOP 
       CLOSE Cur_get_level_itnbr ;

 GET_LEVEL --

LOOP 
        
w_mdi_frame.sle_msg.text = "PROGRESS"


//
//
//
//sle_msg.text = "품번, 공정별 금액 적상"
//    
//////////////////////////////////////////////////////////////////////////////
////
////  * 품번 + 공정순서(OPSEQ) 
////		-> 공정별 외주가공비, 직접인건비, 경비 상위공정순서에 적상  START
////
//////////////////////////////////////////////////////////////////////////////
//dec	dWon_amt
//
//DECLARE C_CUMULATIVE_SEQ CURSOR FOR
// SELECT  ITNBR, CVCOD, OPSEQ
//   FROM  ITEMCC_SEQ
//  WHERE  YYMM = :UE_YYMM 	AND
//  			GUBUN = '1' 
//ORDER BY ITNBR ASC, CVCOD ASC, OPSEQ DESC ;
//
//
//OPEN C_CUMULATIVE_SEQ ;
//
//DO WHILE TRUE
//
//	FETCH C_CUMULATIVE_SEQ 
//	 INTO :GET_ITNBR, :UE_CVCOD, :UE_OPSEQ ;
//
//	IF SQLCA.SQLCODE <> 0 THEN EXIT 
//
//
//	// 표준공정.공정순서
//	SELECT NVL(SUM(WON_AMT), 0)
//	  INTO :dWon_amt
//	  FROM ITEMCC_SEQ
//	 WHERE YYMM = :UE_YYMM		AND
//	 		 ITNBR = :GET_ITNBR	AND
//		    GUBUN = '1'			AND
//			 CVCOD = :UE_CVCOD	AND
//			 OPSEQ < :UE_OPSEQ ;
//	
//	IF ISNULL(dWON_AMT) 	THEN	dWON_AMT = 0
//	
//	IF SQLCA.SQLCODE = 0		THEN
//
//		IF dWON_AMT <> 0	THEN
//			INSERT INTO ITEMCC_SEQ( YYMM, ITNBR, OPSEQ, GUBUN, CVCOD, WON_AMT)
//			VALUES (:UE_YYMM, :GET_ITNBR, :UE_OPSEQ, '2', :UE_CVCOD, :dWON_AMT) ;
//		END IF
//		
//	END IF
//
//
//LOOP
//
//CLOSE C_CUMULATIVE_SEQ ;
//


////////////////////////////////////////////////////////////////////////////
//
//  * 품번 + 공정순서(OPSEQ) 
//		-> 공정별 외주가공비, 직접인건비, 경비 상위공정순서에 적상	END 
//
////////////////////////////////////////////////////////////////////////////





////////////////////////////////////////////////////////////////////////////
// * ITEMCC_SEQ : 품번 + 공정순서(OPSEQ) -> 	공정별 재료비 적상 START
//
//	  SELECT 하위품번 FROM 생산BOM 
//	   WHERE 상위품번 = SEQ.품번 AND 공정 = SEQ.공정순서
//
//   하위품번.재료비 -> 상위품번 + 공정순서별 UPDATE
////////////////////////////////////////////////////////////////////////////
//STRING	sCINBR
//INT		iCOUNT
//
//DECLARE C_BOM CURSOR FOR
// SELECT  ITNBR, OPSEQ
//   FROM  ITEMCC_SEQ
//  WHERE  YYMM = :UE_YYMM 	AND
//  			GUBUN = '1';
//
//
//OPEN C_BOM ;
//DO WHILE TRUE
//
//	FETCH C_BOM INTO :GET_ITNBR, :UE_OPSEQ ;
//
//	IF SQLCA.SQLCODE <> 0 THEN EXIT 
//
//	// 표준공정.공정코드 SELECT
//	DECLARE C_CINBR	CURSOR FOR
//	SELECT DISTINCT CINBR, QTYPR
//	  FROM PSTRUC
//	 WHERE PINBR = :GET_ITNBR	AND
//	 		 USSEQ = :UE_OPSEQ	;
//			 
//	OPEN C_CINBR ;
//	DO WHILE TRUE
//
//		FETCH C_CINBR INTO :sCINBR, :UE_QTYPR;
//
//		IF SQLCA.SQLCODE <> 0 THEN EXIT 
//
//			dWON_AMT = 0
//		  SELECT "WON_AMT"
//		    INTO :dWON_AMT  
//		    FROM "ITEMCC"  
//		   WHERE ( "YYMM" = :UE_YYMM ) AND  
//      		   ( "ITNBR" = :sCINBR ) AND  
//		         ( "GUBUN" IN ('1','2') ) AND  
//      		   ( "CVCOD" = '000001' ) ;
//
//			IF IsNull(dWon_amt)	THEN	dWON_AMT = 0
//		
//			IF dWON_AMT <> 0		THEN
//	
//			  SELECT COUNT(*)
//			    INTO :iCOUNT
//			    FROM "ITEMCC_SEQ"  
//		   	WHERE ( "YYMM" = :UE_YYMM ) AND  
//      			   ( "ITNBR" = :GET_ITNBR ) AND  
//						( "OPSEQ" = :UE_OPSEQ ) AND
//		         	( "GUBUN" = '2' ) AND  
//	      		   ( "CVCOD" = '000001' ) ;
//		
//				IF SQLCA.SQLCODE = 100	THEN
//					INSERT INTO ITEMCC_SEQ(YYMM, ITNBR, OPSEQ, GUBUN, CVCOD, WON_AMT)
//							VALUES(:UE_YYMM, :GET_ITNBR, :UE_OPSEQ, '2', '000001', :dWON_AMT*:UE_QTYPR);
//					INSERT INTO ITEMCC_SEQ(YYMM, ITNBR, OPSEQ, GUBUN, CVCOD, WON_AMT)
//							VALUES(:UE_YYMM, :GET_ITNBR, :UE_OPSEQ, '2', '000002', :dWON_AMT*:UE_QTYPR:GAN_RATE / 100 );
//				ELSE
//
//			  		UPDATE ITEMCC_SEQ
//					   SET WON_AMT = WON_AMT + :dWON_AMT
//			   	WHERE ( "YYMM" = :UE_YYMM ) AND  
//      				   ( "ITNBR" = :GET_ITNBR ) AND  
//							( "OPSEQ" = :UE_OPSEQ ) AND
//		         		( "GUBUN" = '2' ) AND  
//	      		   	( "CVCOD" = '000001' ) ;
//							
//			  		UPDATE ITEMCC_SEQ
//					   SET WON_AMT = WON_AMT + ( :dWON_AMT * :GAN_RATE / 100 )
//			   	WHERE ( "YYMM" = :UE_YYMM ) AND  
//      				   ( "ITNBR" = :GET_ITNBR ) AND  
//							( "OPSEQ" = :UE_OPSEQ ) AND
//		         		( "GUBUN" = '2' ) AND  
//	      		   	( "CVCOD" = '000002' ) ;
//
//				END IF
//
//			END IF
//
//
//	LOOP			 
//
//	CLOSE C_CINBR;
//
//LOOP
//
//CLOSE C_BOM ;
//////////////////////////////////////////////////////////////////////////////
//// * ITEMCC_SEQ : 품번 + 공정순서(OPSEQ) -> 	공정별 재료비 적상  END
//////////////////////////////////////////////////////////////////////////////
//
//

//////////////////////////////////////////////////////////////////////////////
//// * 품번 + 공정(순서) -> 표준공정.공정코드	START
//////////////////////////////////////////////////////////////////////////////
//STRING	sSEQ
//
//DECLARE C_SEQ CURSOR FOR
// SELECT  ITNBR, OPSEQ
//   FROM  ITEMCC_SEQ
//  WHERE  YYMM = :UE_YYMM ;
//
//
//OPEN C_SEQ ;
//DO WHILE TRUE
//
//	FETCH C_SEQ INTO :GET_ITNBR, :UE_OPSEQ ;
//
//	IF SQLCA.SQLCODE <> 0 THEN EXIT 
//
//	// 표준공정.공정코드 SELECT
//	SELECT ROSLT
//	  INTO :sSEQ
//	  FROM ROUTNG
//	 WHERE ITNBR = :GET_ITNBR	AND
//	 		 OPSEQ = :UE_OPSEQ	AND
//			 ROWNUM = 1 ;
//			 
//	IF SQLCA.SQLCODE = 0		THEN
//		
//		UPDATE ITEMCC_SEQ
//		   SET ROSLT = :sSEQ
//		 WHERE YYMM = :UE_YYMM		AND
//		 		 ITNBR = :GET_ITNBR	AND
//				 OPSEQ = :UE_OPSEQ ;
//				 
//	END IF
//
//LOOP
//
//CLOSE C_SEQ ;
//
////////////////////////////////////////////////////////////////////////////
// * 품번 + 공정코드 -> 표준공정.공정순서	END
////////////////////////////////////////////////////////////////////////////
w_mdi_frame.sle_msg.text = "사전원가를 계산 완료"

SetPointer(Arrow!)

COMMIT;	 




end event

type p_1 from uo_picture within w_pdm_01640
integer x = 3945
integer y = 24
integer width = 178
integer taborder = 90
string picturename = "C:\erpman\image\계산_up.gif"
end type

event clicked;call super::clicked;
string 	ue_yymm,		&
			UE_YYMMDD,	&
			sGubun
DEC		Gan_Rate
int	iReturn

w_mdi_frame.sle_msg.text = "사전원가 계산중입니다."

DW_1.ACCEPTTEXT()

UE_YYMMDD = DW_1.GetItemString(1,"sle_yymmdd")
GAN_RATE  = DW_1.GETITEMDECIMAL(1,"GAN_RATE")
Ue_yymm = MID(UE_YYMMDD,1,6)


IF ISNULL(GAN_RATE)	THEN	GAN_RATE = 0

SetPointer(HourGlass!)


IF 	 rb_1.checked = true		THEN
		 sGubun = '1'
ELSEIF rb_2.checked = true		THEN
		 sGubun = '2'
ELSEIF rb_3.checked = true		THEN
		 sGubun = '3'
ELSEIF rb_4.checked = true		THEN
		 sGubun = '4'
ELSE
		 sGubun = '1'
END IF


iReturn = sqlca.F_Standard_Cost(UE_YYMMDD, GAN_RATE, sGubun)

IF  iReturn < 0		THEN

	Messagebox(string(iReturn), "사전원가 계산오류가 발생했습니다.")
	ROLLBACK;
	RETURN

END IF


Commit;

SetPointer(Arrow!)

Messagebox("확인", "사전원가 계산을 완료했습니다.")

w_mdi_frame.sle_msg.text = "사전원가 계산완료"


end event

event ue_lbuttondown;call super::ue_lbuttondown;p_1.PictureName = "C:\erpman\image\계산_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;p_1.PictureName = "C:\erpman\image\계산_up.gif"
end event

type rb_4 from radiobutton within w_pdm_01640
integer x = 2816
integer y = 1720
integer width = 457
integer height = 76
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
string text = "최저입고단가"
end type

type rb_3 from radiobutton within w_pdm_01640
integer x = 2327
integer y = 1720
integer width = 457
integer height = 76
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
string text = "최고입고단가"
end type

type rb_2 from radiobutton within w_pdm_01640
integer x = 1838
integer y = 1720
integer width = 457
integer height = 76
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
string text = "최종입고단가"
end type

type rb_1 from radiobutton within w_pdm_01640
integer x = 1408
integer y = 1720
integer width = 398
integer height = 76
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388736
long backcolor = 33027312
string text = "계약단가"
boolean checked = true
end type

type st_msg from statictext within w_pdm_01640
boolean visible = false
integer x = 91
integer y = 2872
integer width = 3547
integer height = 92
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16776960
long backcolor = 8388608
boolean enabled = false
string text = " 메세지 "
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type st_4 from statictext within w_pdm_01640
integer x = 1509
integer y = 604
integer width = 1714
integer height = 76
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "굴림"
long textcolor = 128
long backcolor = 33027312
boolean enabled = false
string text = "품목,작업장,표준공정,단가정보 이용 가공비계산"
boolean focusrectangle = false
end type

type st_3 from statictext within w_pdm_01640
integer x = 1504
integer y = 516
integer width = 1714
integer height = 76
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "굴림"
long textcolor = 128
long backcolor = 33027312
boolean enabled = false
string text = "품목,작업장,외주공정,단가정보 이용 외주계산"
boolean focusrectangle = false
end type

type st_2 from statictext within w_pdm_01640
integer x = 1504
integer y = 436
integer width = 1714
integer height = 72
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "굴림"
long textcolor = 128
long backcolor = 33027312
boolean enabled = false
string text = "직접재료비 * 간접재료비율 / 100 = 간접재료비 계산"
boolean focusrectangle = false
end type

type st_1 from statictext within w_pdm_01640
integer x = 1509
integer y = 348
integer width = 1714
integer height = 76
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "굴림"
long textcolor = 128
long backcolor = 33027312
boolean enabled = false
string text = "품목,BOM,단가마스타,수입경비 등 이용 직접재료비 계산"
boolean focusrectangle = false
end type

type dw_1 from datawindow within w_pdm_01640
event ue_pressenter pbm_dwnprocessenter
integer x = 1847
integer y = 972
integer width = 1038
integer height = 432
integer taborder = 10
string dataobject = "d_input_yymm"
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;Send(Handle(this),256,9,0)
Return 1
end event

type cb_2 from commandbutton within w_pdm_01640
boolean visible = false
integer x = 2994
integer y = 2724
integer width = 590
integer height = 108
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "표준원가변동사항"
end type

event clicked;SetPointer(HourGlass!)

STRING SUM_ITNBR,SUM_YYMM,SUM_GIJUN_DATE,SUM_SYS_DATE

LONG SUM_TOTAL

DECLARE CUR_TOTAL_SUM CURSOR FOR
   SELECT DISTINCT "ITEMCC"."ITNBR","ITEMCC"."YYMM","ITEMCC"."GIJUN_DATE","ITEMCC"."SYS_DATE"
              FROM "ITEMCC" ;
					 
OPEN CUR_TOTAL_SUM ; 
DO WHILE TRUE 
  FETCH CUR_TOTAL_SUM INTO :SUM_ITNBR,:SUM_YYMM,:SUM_GIJUN_DATE,:SUM_SYS_DATE ;
  
     
IF SQLCA.SQLCODE <> 0 THEN EXIT 
	
	     SELECT SUM("ITEMCC"."WON_AMT")
          INTO :SUM_TOTAL
			 FROM "ITEMCC"
		   WHERE "ITEMCC"."ITNBR" = :SUM_ITNBR AND
			      "ITEMCC"."YYMM" = :SUM_YYMM AND
			      "ITEMCC"."GIJUN_DATE" = :SUM_GIJUN_DATE AND
				   "ITEMCC"."SYS_DATE" = :SUM_SYS_DATE ;

		  
		  INSERT INTO "JEJO_COST"( "ITNBR","YYMM","GIJUN_DATE","SYS_DATE","JEJO_COST" )  
             VALUES (:SUM_ITNBR,:SUM_YYMM,:SUM_GIJUN_DATE,:SUM_SYS_DATE,:SUM_TOTAL)  ;
	        
        SUM_TOTAL = 0
		  
LOOP

CLOSE CUR_TOTAL_SUM ; 

commit;

SetPointer(Arrow!)

OpenWithParm(w_pdm_11760,"sajun_cost_modify")
w_pdm_11760.dw_list.dataobject = 'd_sajun_cost_modify'



end event

type rr_1 from roundrectangle within w_pdm_01640
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 1243
integer y = 224
integer width = 2226
integer height = 532
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_pdm_01640
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 1243
integer y = 824
integer width = 2226
integer height = 740
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_3 from roundrectangle within w_pdm_01640
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 1243
integer y = 1624
integer width = 2226
integer height = 256
integer cornerheight = 40
integer cornerwidth = 55
end type

