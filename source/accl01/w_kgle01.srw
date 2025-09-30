$PBExportHeader$w_kgle01.srw
$PBExportComments$결산관리: 재무제표 조회 출력
forward
global type w_kgle01 from w_standard_print
end type
type p_update from p_retrieve within w_kgle01
end type
type rr_1 from roundrectangle within w_kgle01
end type
end forward

global type w_kgle01 from w_standard_print
string title = "재무제표 조회 출력"
p_update p_update
rr_1 rr_1
end type
global w_kgle01 w_kgle01

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String   s_saupj,ssql_saupj,s_fsgu,s_jasaname,sFrYmdD,sToYmdD,sFrYmdJ,sToYmdJ,sLangGbn,sCfDt
Integer  iFunVal,Id_Ses,Ij_Ses

w_mdi_frame.sle_msg.text =""

dw_ip.AcceptText()

s_saupj = dw_ip.GetItemString(dw_ip.Getrow(),"saupj")
Id_Ses  = dw_ip.getItemNumber(dw_ip.Getrow(),"d_ses")
sFrYmdD = Trim(dw_ip.GetItemString(dw_ip.Getrow(),"d_frymd"))
sToYmdD = Trim(dw_ip.GetItemString(dw_ip.Getrow(),"d_toymd"))

IJ_Ses  = dw_ip.getItemNumber(dw_ip.Getrow(),"j_ses")
sFrYmdJ = Trim(dw_ip.GetItemString(dw_ip.Getrow(),"j_frymd"))
sToYmdJ = Trim(dw_ip.GetItemString(dw_ip.Getrow(),"j_toymd"))

sLangGbn = dw_ip.GetItemString(dw_ip.Getrow(),"langgbn")
s_fsgu   = dw_ip.GetItemString(dw_ip.GetRow(),"gubun")
sCfDt    = Trim(dw_ip.GetItemString(dw_ip.GetRow(),"confirm_dt"))

IF s_saupj ="" OR IsNull(s_saupj) THEN
	F_MessageChk(1,'[사업장]')
	dw_ip.SetColumn("saupj")
	dw_ip.SetFocus()
	Return -1
ELSE
	SELECT "RFNA1"		INTO :ssql_saupj
		FROM "REFFPF"
		WHERE "RFCOD" ='AD' AND	"RFGUB" =:s_saupj ;
	IF SQLCA.SQLCODE <> 0 THEN
		F_MessageChk(20,'[사업장]')
		dw_ip.SetColumn("saupj")
		dw_ip.SetFocus()
		Return -1
	END IF
END IF

IF dw_ip.GetItemString(dw_ip.Getrow(),"d_frymd") ="" OR &
	IsNull(dw_ip.GetItemString(dw_ip.Getrow(),"d_frymd")) THEN
	w_mdi_frame.sle_msg.text ="회기가 등록되지 않았습니다. 먼저 회기를 등록하세요.!!"
	MessageBox("확 인","회기를 입력하세요.!!")
	Return -1
END IF
IF s_fsgu ="" OR IsNull(s_fsgu) THEN
	F_MessageChk(1,'[결산서종류]')
	dw_ip.SetColumn("gubun")
	dw_ip.SetFocus()
	Return -1
END IF

IF MessageBox('확 인','자료를 생성하시겠습니까?',Question!,YesNo!) = 1 THEN
	
	IF s_fsgu = '4' and (sCfDt = '' or IsNull(sCfDt)) THEN
		F_MessageChk(1,'[처분확정일]')
		dw_ip.SetColumn("confirm_dt")
		dw_ip.SetFocus()
		Return -1
	END IF
	
	IF MessageBox('확 인','가결산을 포함하시겠습니까?',Question!, YesNo!) = 1 THEN
		sle_msg.text ="실결산 처리 중(시산표 복사)..."
		IF f_closing_copy(sFrYmdD,sToYmdD,sFrYmdJ,sToYmdJ) <> 1 THEN
			MessageBox("확 인","시산표 복사 실패 !!")
			Return -1
		END IF
		
		sle_msg.text = '가결산 전표 집계 중...'
		IF f_closing_sum(Left(sFrYmdD,6),Left(sToYmdD,6)) <> 1 THEN
			MessageBox("확 인","가결산집계 실패 !!")
			RETURN -1
		END IF
		sle_msg.text = '가결산 전표 집계 완료!!'
	ELSE
		w_mdi_frame.sle_msg.text ="실결산 처리 중(시산표 복사)..."
		IF f_closing_copy(sFrYmdD,sToYmdD,sFrYmdJ,sToYmdJ) <> 1 THEN
			MessageBox("확 인","시산표 복사 실패 !!")
			Return -1
		END IF
	END IF
	
	w_mdi_frame.sle_msg.text = '재무제표 자료 생성 중...'
	iFunVal = sqlca.fun_create_fs(s_saupj,Id_Ses,sFrYmdD,sToYmdD,Ij_Ses,sFrYmdJ,sToYmdJ,s_fsgu)
	IF iFunVal = -1 THEN
		MessageBox('확 인','결산자료 저장 실패!')
		Return -1
	ELSEIF iFunVal = -2 THEN
		MessageBox('확 인','금액계산 실패!')
		Return -1
	ELSEIF iFunVal = -3 THEN
		MessageBox('확 인','금액(연산)계산 실패!')
		Return -1
	ELSEIF iFunVal = 0 THEN	
		F_MessageChk(59,'')
		Return -1
	ELSE
		w_mdi_frame.sle_msg.Text = '재무제표 자료 작성 완료!!'
		SetPointer(Arrow!)
	END IF
	Commit;
	
	/*이익잉여금처분계산서 처분확정일 수정*/
	if s_fsgu = '4' then
		update kfz02wk
			set acc_ym = :sCfDt
			where saupj = :s_saupj and curr_from_date = :sFrYmdD and curr_to_date = :sToYmdD and
					prv_from_date = :sFrYmdJ and prv_to_date = :sToYmdJ and fs_gu = :s_fsgu;
		if sqlca.sqlcode <> 0 then
			Rollback;
			F_MessageChk(13,'처분확정일 갱신')
			Return -1
		end if
		Commit;
	end if
END IF

/*자사명 //SYSCNFG의 공통+1+'10'의 자료값으로 거래처명을 가져옴*/
SELECT "RFNA1"		INTO :s_jasaname  
	FROM "REFFPF"
	WHERE "RFCOD" ='AD' AND	"RFGUB" =:s_saupj ;
	
String sBefConFirm

select distinct acc_ym into :sBefConFirm
	from kfz02wk
	where saupj = :s_saupj and curr_from_date = :sFrYmdJ and curr_to_date = :sToYmdJ and
		   fs_gu = :s_fsgu and rownum = 1;

IF dw_print.Retrieve(s_saupj,sFrYmdD,sToYmdD,sFrYmdJ,sToYmdJ,s_fsgu,sLangGbn) <=0 THEN
	F_MessageChk(14,'')
	Return -1
END IF
dw_print.ShareData(dw_list)
dw_print.Modify("saupjname.text ='"+s_jasaname+"'")
dw_print.Modify("t_bef_confirm.text ='"+String(sBefConFirm,'@@@@년 @@월 @@일')+"'")
Return 1
end function

on w_kgle01.create
int iCurrent
call super::create
this.p_update=create p_update
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.p_update
this.Control[iCurrent+2]=this.rr_1
end on

on w_kgle01.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.p_update)
destroy(this.rr_1)
end on

event open;call super::open;String sMaxDate,sCurrF,sCurrT,sPrvF,sPrvT
Long   lCurr,lPrv

dw_ip.SetItem(dw_ip.GetRow(),"saupj",gs_saupj)
dw_ip.SetItem(dw_ip.GetRow(),"gubun",'1')

dw_ip.Setcolumn("saupj")
dw_ip.SetFocus()

SELECT MAX("CURR_FROM_DATE"||"CURR_TO_DATE"||"PRV_FROM_DATE"||"PRV_TO_DATE")
	INTO :sMaxDate
   FROM "KFZ02WK"   WHERE "SAUPJ" = :Gs_Saupj ;
IF SQLCA.SQLCODE <> 0 OR sMaxDate = '' or IsNull(sMaxDate) THEN
	select d_ses,		d_frymd,		d_toymd,		j_ses,		j_frymd,		j_toymd
		into :lCurr,	:sCurrF,		:sCurrT,		:lPrv,		:sPrvF,		:sPrvT
    	from kfz08om0 ;
	
ELSE
	sCurrF = Left(sMaxDate,8);		sCurrT = Mid(sMaxDate,9,8);
	sPrvF  = Mid(sMaxDate,17,8);  sPrvT  = Right(sMaxDate,8);

	SELECT "CURR_YEAR",   "PRV_YEAR"		INTO :lCurr,		 :lPrv
		FROM "KFZ02WK"  
		WHERE "SAUPJ" = :Gs_Saupj AND
				"CURR_FROM_DATE" = :sCurrF AND "CURR_TO_DATE" = :sCurrT AND
				"PRV_FROM_DATE"  = :sPrvF AND  "PRV_TO_DATE"  = :sPrvT ;
END IF

dw_ip.SetItem(1,"d_ses",   lCurr)
dw_ip.SetItem(1,"j_ses",   lPrv)
dw_ip.SetItem(1,"d_frymd", sCurrF)
dw_ip.SetItem(1,"d_toymd", sCurrT)
dw_ip.SetItem(1,"j_frymd", sPrvF)
dw_ip.SetItem(1,"j_toymd", sPrvT)

//dw_list.Title ="손익계산서 조회"
dw_list.DataObject ="dw_kgle01_1"
dw_list.SetRedraw(True)
dw_list.SetTransObject(SQLCA)

dw_print.DataObject ="dw_kgle01_1_p"
dw_print.SetRedraw(True)
dw_print.SetTransObject(SQLCA)


end event

type p_xls from w_standard_print`p_xls within w_kgle01
end type

type p_sort from w_standard_print`p_sort within w_kgle01
end type

type p_preview from w_standard_print`p_preview within w_kgle01
integer x = 4270
integer taborder = 30
string pointer = ""
end type

type p_exit from w_standard_print`p_exit within w_kgle01
integer taborder = 40
string pointer = ""
end type

type p_print from w_standard_print`p_print within w_kgle01
boolean visible = false
integer x = 4443
integer y = 180
integer taborder = 0
string pointer = ""
end type

type p_retrieve from w_standard_print`p_retrieve within w_kgle01
integer x = 4096
integer y = 20
string pointer = ""
end type

type st_window from w_standard_print`st_window within w_kgle01
integer x = 2377
integer width = 462
end type

type sle_msg from w_standard_print`sle_msg within w_kgle01
integer width = 1984
end type

type dw_datetime from w_standard_print`dw_datetime within w_kgle01
integer x = 2839
end type

type st_10 from w_standard_print`st_10 within w_kgle01
end type

type gb_10 from w_standard_print`gb_10 within w_kgle01
integer width = 3584
end type

type dw_print from w_standard_print`dw_print within w_kgle01
integer x = 4027
integer y = 184
integer width = 119
integer height = 120
string dataobject = "dw_kgle01_1_P"
end type

type dw_ip from w_standard_print`dw_ip within w_kgle01
integer x = 46
integer y = 24
integer width = 3877
integer height = 216
string dataobject = "dw_kgle01_0"
end type

event dw_ip::itemchanged;
IF dwo.name ="gubun" THEN
	dw_list.SetRedraw(False)

	IF data ='4' THEN
		dw_list.DataObject ="dw_kgle01_4"
		dw_print.DataObject ="dw_kgle01_4_p"
		
		p_update.Enabled = True
		p_update.PictureName = 'C:\erpman\image\저장_up.gif'
	ELSE
		dw_list.DataObject ="dw_kgle01_1"
		dw_print.DataObject ="dw_kgle01_1_p"
		
		p_update.Enabled = True
		p_update.PictureName = 'C:\erpman\image\저장_d.gif'
	END IF
	dw_list.SetRedraw(True)
	
	dw_list.SetTransObject(SQLCA)	
	dw_print.SetTransObject(sqlca)
END IF

end event

event dw_ip::itemerror;Return 1
end event

event dw_ip::getfocus;this.AcceptText()
end event

event dw_ip::rbuttondown;String   sNull
Integer  lNull

SetNull(sNull);	SetNull(lNull);

this.AcceptText()
IF this.GetColumnName() = 'd_ses' THEN
	SetNull(Gs_Code);			SetNull(Gs_Gubun)
	
	Gs_Gubun = this.GetItemString(this.GetRow(),"saupj")
	
	Gs_Code = String(this.GetItemNumber(this.GetRow(),"d_ses"))
	IF IsNull(Gs_Code) THEN Gs_Code = ''
	
	Open(W_kfz02wk_popup)
	
	IF IsNull(Gs_Code) OR Gs_Code = '' THEN Return
		
	this.SetItem(1,"d_ses",   Integer(Left(Gs_Code,3)))
	this.SetItem(1,"d_frymd", Mid(Gs_Code,4,8))
	this.SetItem(1,"d_toymd", Mid(Gs_Code,12,8))
	
	this.SetItem(1,"j_ses",   Integer(Mid(Gs_Code,20,3)))
	this.SetItem(1,"j_frymd", Mid(Gs_Code,23,8))
	this.SetItem(1,"j_toymd", Mid(Gs_Code,31,8))

	this.SetColumn("gubun")
	this.SetFocus()
END IF

end event

type dw_list from w_standard_print`dw_list within w_kgle01
integer x = 78
integer y = 252
integer width = 4498
integer height = 1956
integer taborder = 0
string dataobject = "dw_kgle01_1"
boolean hscrollbar = false
boolean border = false
boolean hsplitscroll = false
end type

type p_update from p_retrieve within w_kgle01
boolean visible = false
integer x = 4256
integer y = 180
integer taborder = 0
boolean bringtotop = true
boolean enabled = false
string picturename = "C:\erpman\image\저장_d.gif"
end type

event ue_lbuttondown;PictureName = 'C:\erpman\image\저장_dn.gif'
end event

event ue_lbuttonup;PictureName = 'C:\erpman\image\저장_up.gif'
end event

event clicked;String   s_saupj,ssql_saupj,s_fsgu,s_jasaname,sFrYmdD,sToYmdD,sFrYmdJ,sToYmdJ,sLangGbn,sCfDt
Integer  iFunVal,Id_Ses,Ij_Ses

w_mdi_frame.sle_msg.text =""

dw_ip.AcceptText()

s_saupj = dw_ip.GetItemString(dw_ip.Getrow(),"saupj")
Id_Ses  = dw_ip.getItemNumber(dw_ip.Getrow(),"d_ses")
sFrYmdD = Trim(dw_ip.GetItemString(dw_ip.Getrow(),"d_frymd"))
sToYmdD = Trim(dw_ip.GetItemString(dw_ip.Getrow(),"d_toymd"))

IJ_Ses  = dw_ip.getItemNumber(dw_ip.Getrow(),"j_ses")
sFrYmdJ = Trim(dw_ip.GetItemString(dw_ip.Getrow(),"j_frymd"))
sToYmdJ = Trim(dw_ip.GetItemString(dw_ip.Getrow(),"j_toymd"))

sLangGbn = dw_ip.GetItemString(dw_ip.Getrow(),"langgbn")
s_fsgu   = dw_ip.GetItemString(dw_ip.GetRow(),"gubun")
sCfDt    = Trim(dw_ip.GetItemString(dw_ip.GetRow(),"confirm_dt"))

if s_fsgu = '4' then
	IF f_dbConFirm('저장') = 2 THEN RETURN
	
	IF sCfDt = '' or IsNull(sCfDt) THEN
		F_MessageChk(1,'[처분확정일]')
		dw_ip.SetColumn("confirm_dt")
		dw_ip.SetFocus()
		Return 
	END IF
	
	IF dw_list.Update() = 1 THEN
		
		update kfz02wk
			set acc_ym = :sCfDt
			where saupj = :s_saupj and curr_from_date = :sFrYmdD and curr_to_date = :sToYmdD and
					prv_from_date = :sFrYmdJ and prv_to_date = :sToYmdJ and fs_gu = :s_fsgu;
		if sqlca.sqlcode <> 0 then
			Rollback;
			F_MessageChk(13,'처분확정일 갱신')
			Return -1
		end if
	
		commit;
		w_mdi_frame.sle_msg.text ="자료가 저장되었습니다.!!!"
	ELSE
		ROLLBACK;
		f_messagechk(13,'')
		Return
	END IF
	
	/*자사명 //SYSCNFG의 공통+1+'10'의 자료값으로 거래처명을 가져옴*/
	SELECT "RFNA1"		INTO :s_jasaname  
		FROM "REFFPF"
		WHERE "RFCOD" ='AD' AND	"RFGUB" =:s_saupj ;
		
	String sBefConFirm
	
	select distinct acc_ym into :sBefConFirm
		from kfz02wk
		where saupj = :s_saupj and curr_from_date = :sFrYmdJ and curr_to_date = :sToYmdJ and
				fs_gu = :s_fsgu and rownum = 1;
	
	IF dw_print.Retrieve(s_saupj,sFrYmdD,sToYmdD,sFrYmdJ,sToYmdJ,s_fsgu,sLangGbn) <=0 THEN
		F_MessageChk(14,'')
		Return -1
	END IF
	
	dw_print.ShareData(dw_list)
	
	dw_print.Modify("saupjname.text ='"+s_jasaname+"'")
	dw_print.Modify("t_bef_confirm.text ='"+String(sBefConFirm,'@@@@년 @@월 @@일')+"'")

end if



end event

type rr_1 from roundrectangle within w_kgle01
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 55
integer y = 240
integer width = 4544
integer height = 1984
integer cornerheight = 40
integer cornerwidth = 55
end type

