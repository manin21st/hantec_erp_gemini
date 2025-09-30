$PBExportHeader$w_kfia21a.srw
$PBExportComments$일집계 화면
forward
global type w_kfia21a from window
end type
type rr_1 from roundrectangle within w_kfia21a
end type
type st_3 from statictext within w_kfia21a
end type
type p_exit from uo_picture within w_kfia21a
end type
type p_can from uo_picture within w_kfia21a
end type
type st_date from statictext within w_kfia21a
end type
type st_2 from statictext within w_kfia21a
end type
type em_datet from editmask within w_kfia21a
end type
type uo_progress from u_progress_bar within w_kfia21a
end type
type st_1 from statictext within w_kfia21a
end type
type em_datef from editmask within w_kfia21a
end type
type ln_1 from line within w_kfia21a
end type
type ln_2 from line within w_kfia21a
end type
end forward

global type w_kfia21a from window
integer x = 946
integer y = 352
integer width = 1394
integer height = 624
boolean titlebar = true
string title = "일집계 처리"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 32106727
rr_1 rr_1
st_3 st_3
p_exit p_exit
p_can p_can
st_date st_date
st_2 st_2
em_datet em_datet
uo_progress uo_progress
st_1 st_1
em_datef em_datef
ln_1 ln_1
ln_2 ln_2
end type
global w_kfia21a w_kfia21a

forward prototypes
public function integer wf_upcross (string sjip_datef, string sjip_datet)
end prototypes

public function integer wf_upcross (string sjip_datef, string sjip_datet);
Int il_Count
String sFin_cd, test_cd,sCurDate
Double dpl_tot, dac_tot  

declare cur_kfm11ot0 cursor for
	select finance_cd	from kfm10om0 where auto_cd = 'C' order by finance_cd asc;

open cur_kfm11ot0;

SetPointer(HourGlass!)

DO WHILE true
	Fetch cur_kfm11ot0 into :sFin_Cd ;
	if sqlca.sqlcode <> 0 then exit
	
	sCurDate = sJip_DateF	
	Do
		select sum(nvl(b.plan_amt,0)), sum(nvl(b.actual_amt,0))
			into :dpl_tot,					 :dac_tot
			from (select * from kfm10om0
						connect by prior finance_cd = sfin_cd
						start with sfin_cd = :sFin_Cd) a,
					kfm11ot0 b
			where a.finance_cd = b.finance_cd and a.auto_cd = 'N' and b.finance_date = :sCurDate;
		if sqlca.sqlcode <> 0 then Return -1
		
		if IsNull(dpl_tot) then dpl_tot = 0
		if IsNull(dac_tot) then dac_tot = 0

		select finance_cd		into :test_cd
			from kfm11ot0
			where finance_cd = :sFin_Cd and finance_date = :sCurDate;
		if sqlca.sqlcode = 0 then
			update kfm11ot0
				set plan_amt   = :dpl_tot,
					 actual_amt = :dac_tot
				where finance_cd = :sFin_Cd and finance_date = :sCurDate;
			if sqlca.sqlcode <> 0 then return -1
		elseif sqlca.sqlcode = 100 then
			insert into kfm11ot0
				( finance_cd,	finance_date,	plan_amt,	actual_amt)
			values
				( :sFin_Cd,		:sCurDate,		:dpl_tot,	:dac_tot);
			if sqlca.sqlcode <> 0 then return -1
		else
			return -1
		end if
		sCurDate = String(RelativeDate(Date(Left(sCurDate,4)+'.'+Mid(sCurDate,5,2)+'.'+Right(sCurDate,2)),1),'yyyymmdd')
	loop while sCurDate <= sJip_DateT
LOOP

close cur_kfm11ot0;
SetPointer(Arrow!)
Return 1
end function

on w_kfia21a.create
this.rr_1=create rr_1
this.st_3=create st_3
this.p_exit=create p_exit
this.p_can=create p_can
this.st_date=create st_date
this.st_2=create st_2
this.em_datet=create em_datet
this.uo_progress=create uo_progress
this.st_1=create st_1
this.em_datef=create em_datef
this.ln_1=create ln_1
this.ln_2=create ln_2
this.Control[]={this.rr_1,&
this.st_3,&
this.p_exit,&
this.p_can,&
this.st_date,&
this.st_2,&
this.em_datet,&
this.uo_progress,&
this.st_1,&
this.em_datef,&
this.ln_1,&
this.ln_2}
end on

on w_kfia21a.destroy
destroy(this.rr_1)
destroy(this.st_3)
destroy(this.p_exit)
destroy(this.p_can)
destroy(this.st_date)
destroy(this.st_2)
destroy(this.em_datet)
destroy(this.uo_progress)
destroy(this.st_1)
destroy(this.em_datef)
destroy(this.ln_1)
destroy(this.ln_2)
end on

event open;String sDate

F_Window_Center_Response(This)

sDate = Message.StringParm

em_datef.text = Left(sDate,4)+'.'+Mid(sDate,5,2)+'.'+Mid(sDate,7,2)
em_datet.text = Mid(sDate,9,4)+'.'+Mid(sDate,13,2)+'.'+Mid(sDate,15,2)

em_datef.SetFocus()

uo_progress.Hide()
st_date.Visible = False
end event

type rr_1 from roundrectangle within w_kfia21a
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 50
integer y = 164
integer width = 1285
integer height = 228
integer cornerheight = 40
integer cornerwidth = 55
end type

type st_3 from statictext within w_kfia21a
integer x = 73
integer y = 248
integer width = 64
integer height = 48
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 32106727
string text = "*"
alignment alignment = center!
boolean focusrectangle = false
end type

type p_exit from uo_picture within w_kfia21a
integer x = 1001
integer width = 178
integer taborder = 30
string pointer = "C:\erpman\cur\confirm.cur"
string picturename = "C:\erpman\image\확인_up.gif"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\확인_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\확인_up.gif"
end event

event clicked;call super::clicked;Int il_cursor_cnt,il_meterPosition,il_Count,k,il_select_cnt
String sIo_dateF,sIo_DateT,sFin_cd,sAdd_cd[5],sSub_cd[5],sIwolFlag,sBefDay,sCurDate
Double dAdd_plan_amount,dAdd_actu_amount,dSub_plan_amount,dSub_actu_amount,&
		 dtotal_plan_add, dtotal_actu_add, dtotal_plan_sub, dtotal_actu_sub,&
		 dLast_Plan,dLast_Actu, dIwol_Plan_Amt,dIwol_Actu_Amt

dtotal_plan_add = 0
dtotal_actu_add = 0
dtotal_plan_sub = 0
dtotal_actu_sub = 0
dLast_Plan      = 0
dLast_Actu      = 0

sIo_dateF = Left(trim(em_dateF.text),4) +Mid(trim(em_dateF.text),6,2) + Right(trim(em_dateF.text),2)
sIo_dateT = Left(trim(em_dateT.text),4) +Mid(trim(em_dateT.text),6,2) + Right(trim(em_dateT.text),2)

IF sIo_dateF = "" OR IsNull(sIo_dateF) THEN
	Messagebox("확 인","일집계일자를 입력하세요!!")
	em_dateF.SetFocus()
	Return 
END IF
IF sIo_dateT = "" OR IsNull(sIo_dateT) THEN
	Messagebox("확 인","일집계일자를 입력하세요!!")
	em_dateT.SetFocus()
	Return 
END IF

//자동계산여부 ='상위집계' 일때 상위코드로 금액을 적상하는 윈도우 함수//
IF wf_upcross(sIo_dateF,sIo_DateT) = -1 THEN 
	Messagebox("확 인","자료 저장을 실패하였습니다!!")
	ROLLBACK;
	SetPointer(Arrow!)
   RETURN
END IF

/*자동계산여부 'Y' 일때는 바로 처리한다.*/
SELECT COUNT(*) INTO :il_Count FROM "KFM10OM0"  WHERE "KFM10OM0"."AUTO_CD" = 'Y'   ;

DECLARE cur_kfm10om0 CURSOR FOR  
	SELECT "KFM10OM0"."FINANCE_CD",   "KFM10OM0"."ADD_CD1",      "KFM10OM0"."ADD_CD2",      
	       "KFM10OM0"."ADD_CD3",      "KFM10OM0"."ADD_CD4",      "KFM10OM0"."ADD_CD5",   
          "KFM10OM0"."SUB_CD1",      "KFM10OM0"."SUB_CD2",      "KFM10OM0"."SUB_CD3", 
			 "KFM10OM0"."SUB_CD4",      "KFM10OM0"."SUB_CD5",      "KFM10OM0"."TRANSE_CD"  
	FROM "KFM10OM0"  
   WHERE "KFM10OM0"."AUTO_CD" = 'Y'   
	ORDER BY "KFM10OM0"."FINANCE_CD" ASC  ;
uo_progress.Show()
st_date.Visible = True

SetPointer(HourGlass!)

sCurDate = sIo_DateF
Do	
	il_cursor_cnt = 1
	
	st_date.Text = Left(sCurDate,4)+'.'+Mid(sCurDate,5,2)+'.'+Right(sCurDate,2)

	OPEN cur_kfm10om0;

	DO WHILE TRUE
		FETCH cur_kfm10om0 INTO :sFin_cd,  			:sAdd_cd[1],    	:sAdd_cd[2],
										:sAdd_cd[3],		:sAdd_cd[4],		:sAdd_cd[5],
										:sSub_cd[1],		:sSub_cd[2],		:sSub_cd[3],
										:sSub_cd[4],		:sSub_cd[5],      :sIwolFlag ;
		IF SQLCA.SQLCODE <> 0 THEN EXIT
		
		il_meterPosition = (il_cursor_cnt/ il_Count) * 100
		uo_progress.uf_set_position (il_meterPosition)
			
		IF sIwolFlag = 'Y' THEN
			SELECT MAX("KFM11OT0"."FINANCE_DATE") 		INTO :sBefDay
				FROM "KFM11OT0"
				WHERE ( "KFM11OT0"."FINANCE_DATE" < :sCurDate );
			IF SQLCA.SQLCODE <> 0 THEN
				dLast_Actu = 0;			dLast_Plan = 0;
			ELSE
				IF IsNull(sBefDay) OR sBefDay = '' THEN
					dLast_Actu = 0;			dLast_Plan = 0;
				ELSE
					SELECT NVL("KFM11OT0"."PLAN_AMT",0),NVL("KFM11OT0"."ACTUAL_AMT",0)  	//전일잔액
						INTO :dIwol_Plan_Amt,			   :dIwol_Actu_Amt  
						FROM "KFM11OT0","KFM10OM0"  
						WHERE ("KFM11OT0"."FINANCE_CD" = "KFM10OM0"."FINANCE_CD") AND
								( "KFM10OM0"."LAST_CD" = 'Y' AND "KFM11OT0"."FINANCE_DATE" = :sBefDay );		
					IF SQLCA.SQLCODE <> 0 THEN
						dIwol_Plan_Amt =0
						dIwol_Actu_Amt =0
					ELSE
						IF IsNull(dIwol_Plan_Amt) THEN dIwol_Plan_Amt = 0
						IF IsNull(dIwol_Actu_Amt) THEN dIwol_Actu_Amt = 0			
					END IF
					
					dLast_Plan = dIwol_Plan_Amt
					dLast_Actu = dIwol_Actu_Amt
				END IF
			END IF
		ELSE
			FOR k = 1 TO 5
				IF sAdd_cd[k] = "" OR sAdd_cd[k] = ' ' OR IsNull(sAdd_cd[k]) THEN
					dAdd_plan_amount =0
					dAdd_actu_amount =0
				ELSE
					SELECT NVL("KFM11OT0"."PLAN_AMT",0),NVL("KFM11OT0"."ACTUAL_AMT",0)  	//연산(+)
						INTO :dAdd_plan_amount,				:dAdd_actu_amount  
						FROM "KFM11OT0"  
						WHERE ( "KFM11OT0"."FINANCE_CD" = :sAdd_cd[k] ) AND  
								( "KFM11OT0"."FINANCE_DATE" = :sCurDate )   ;
					IF SQLCA.SQLCODE <> 0 THEN
						dAdd_plan_amount =0
						dAdd_actu_amount =0
						
					END IF
				END IF
			
				dtotal_plan_add = dtotal_plan_add + dAdd_plan_amount
				dtotal_actu_add = dtotal_actu_add + dAdd_actu_amount
		
				IF sSub_cd[k] = "" OR sSub_cd[k] = ' ' OR IsNull(sSub_cd[k]) THEN
					dSub_plan_amount =0
					dSub_actu_amount =0
				ELSE
					SELECT NVL("KFM11OT0"."PLAN_AMT",0),NVL("KFM11OT0"."ACTUAL_AMT",0)  	//연산(-)
						INTO :dSub_plan_amount,				:dSub_actu_amount  
						FROM "KFM11OT0"  
						WHERE ( "KFM11OT0"."FINANCE_CD" = :sSub_cd[k] ) AND  
								( "KFM11OT0"."FINANCE_DATE" = :sCurDate )   ;
					IF SQLCA.SQLCODE <> 0 THEN
						dSub_plan_amount =0
						dSub_actu_amount =0
					END IF
				END IF
				
				dtotal_plan_sub = dtotal_plan_sub + dSub_plan_amount
				dtotal_actu_sub = dtotal_actu_sub + dSub_actu_amount
			NEXT
				
			dLast_Plan = dtotal_plan_add - dtotal_plan_sub				// 계획 = 연산(+)합 - 연산(-)합
			dLast_Actu = dtotal_actu_add - dtotal_actu_sub				// 실적 = 연산(+)합 - 연산(-)합
		END IF	
		
		SELECT COUNT(*)	INTO :il_select_cnt
			FROM "KFM11OT0"  
			WHERE ( "KFM11OT0"."FINANCE_CD" = :sFin_cd ) AND ( "KFM11OT0"."FINANCE_DATE" = :sCurDate )   ;
		IF il_select_cnt = 1 THEN
			UPDATE "KFM11OT0"  
				SET "PLAN_AMT"     = :dLast_Plan,   
					 "ACTUAL_AMT"   = :dLast_Actu
				WHERE ( "KFM11OT0"."FINANCE_CD" = :sFin_cd ) AND ( "KFM11OT0"."FINANCE_DATE" = :sCurDate )   ;
		ELSE
			INSERT INTO "KFM11OT0"  
				( "FINANCE_CD",   "FINANCE_DATE",   "PLAN_AMT",   "ACTUAL_AMT" )  
			VALUES ( :sFin_cd,   :sCurDate,        :dLast_Plan,  :dLast_Actu )  ;
		END IF
		
		IF SQLCA.SQLCODE <> 0 THEN
			Messagebox("확 인","자료 저장을 실패하였습니다!!")
			ROLLBACK;
			uo_progress.Hide()
			Return
		ELSE
			Commit;
		END IF
		
		dtotal_plan_add = 0
		dtotal_actu_add = 0
		
		dtotal_plan_sub = 0
		dtotal_actu_sub = 0
		
		dLast_Plan      = 0
		dLast_Actu      = 0
			
		il_cursor_cnt = il_cursor_cnt + 1
	LOOP
	CLOSE cur_kfm10om0;
	
	sCurDate = String(RelativeDate(Date(Left(sCurDate,4)+'.'+Mid(sCurDate,5,2)+'.'+Right(sCurDate,2)),1),'yyyymmdd')
Loop While sCurDate <= sIo_DateT

uo_progress.Hide()
st_date.Visible = False

SetPointer(Arrow!)

COMMIT;

close(parent)
	
end event

type p_can from uo_picture within w_kfia21a
integer x = 1175
integer width = 178
integer taborder = 40
string pointer = "C:\erpman\cur\cancel.cur"
string picturename = "C:\erpman\image\취소_up.gif"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event clicked;call super::clicked;close(parent)
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\취소_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\취소_up.gif"
end event

type st_date from statictext within w_kfia21a
integer x = 87
integer y = 432
integer width = 352
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
alignment alignment = center!
boolean focusrectangle = false
end type

type st_2 from statictext within w_kfia21a
integer x = 832
integer y = 256
integer width = 46
integer height = 48
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
boolean enabled = false
string text = "-"
alignment alignment = center!
boolean focusrectangle = false
end type

type em_datet from editmask within w_kfia21a
integer x = 882
integer y = 248
integer width = 402
integer height = 64
integer taborder = 20
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 16777215
boolean border = false
alignment alignment = center!
maskdatatype maskdatatype = datemask!
string mask = "yyyy.mm.dd"
boolean autoskip = true
end type

type uo_progress from u_progress_bar within w_kfia21a
integer x = 453
integer y = 432
integer width = 827
integer height = 72
end type

on uo_progress.destroy
call u_progress_bar::destroy
end on

type st_1 from statictext within w_kfia21a
integer x = 133
integer y = 248
integer width = 297
integer height = 76
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
boolean enabled = false
string text = "일집계일자"
boolean focusrectangle = false
end type

type em_datef from editmask within w_kfia21a
integer x = 430
integer y = 248
integer width = 402
integer height = 64
integer taborder = 10
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 16777215
boolean border = false
alignment alignment = center!
maskdatatype maskdatatype = datemask!
string mask = "yyyy.mm.dd"
boolean autoskip = true
end type

type ln_1 from line within w_kfia21a
integer linethickness = 1
integer beginx = 439
integer beginy = 312
integer endx = 837
integer endy = 312
end type

type ln_2 from line within w_kfia21a
integer linethickness = 1
integer beginx = 891
integer beginy = 312
integer endx = 1289
integer endy = 312
end type

