$PBExportHeader$w_kifa32a.srw
$PBExportComments$자동전표 관리 : 급여(급여항목별 계정등록)
forward
global type w_kifa32a from window
end type
type p_mod from uo_picture within w_kifa32a
end type
type p_exit from uo_picture within w_kifa32a
end type
type dw_ins from u_key_enter within w_kifa32a
end type
type rb_sub from radiobutton within w_kifa32a
end type
type rb_pay from radiobutton within w_kifa32a
end type
type dw_lst from datawindow within w_kifa32a
end type
type gb_1 from groupbox within w_kifa32a
end type
type rr_1 from roundrectangle within w_kifa32a
end type
end forward

global type w_kifa32a from window
integer x = 59
integer y = 276
integer width = 3511
integer height = 1920
boolean titlebar = true
string title = "급여항목별 계정과목 등록"
windowtype windowtype = response!
long backcolor = 32106727
p_mod p_mod
p_exit p_exit
dw_ins dw_ins
rb_sub rb_sub
rb_pay rb_pay
dw_lst dw_lst
gb_1 gb_1
rr_1 rr_1
end type
global w_kifa32a w_kifa32a

type variables
String      LsPaySubFlag
Boolean  Ib_any_typing
end variables

forward prototypes
public subroutine wf_init_ins ()
end prototypes

public subroutine wf_init_ins ();dw_ins.SetRedraw(False)
IF dw_ins.Retrieve(dw_lst.GetItemString(dw_lst.GetSelectedRow(0),"allowcode"),LsPaySubFlag) <=0 THEN
	dw_ins.InsertRow(0)
	dw_ins.SetItem(dw_ins.GetRow(),"allowcode",dw_lst.GetItemString(dw_lst.GetSelectedRow(0),"allowcode"))
	dw_ins.SetItem(dw_ins.GetRow(),"paysubtag",lspaysubflag)
END IF
dw_ins.SetRedraw(True)

IF LsPaySubFlag = '1' THEN
	dw_ins.SetColumn("accode1")
ELSE
	dw_ins.SetColumn("accode16")
END IF
dw_ins.SetFocus()
	
end subroutine

on w_kifa32a.create
this.p_mod=create p_mod
this.p_exit=create p_exit
this.dw_ins=create dw_ins
this.rb_sub=create rb_sub
this.rb_pay=create rb_pay
this.dw_lst=create dw_lst
this.gb_1=create gb_1
this.rr_1=create rr_1
this.Control[]={this.p_mod,&
this.p_exit,&
this.dw_ins,&
this.rb_sub,&
this.rb_pay,&
this.dw_lst,&
this.gb_1,&
this.rr_1}
end on

on w_kifa32a.destroy
destroy(this.p_mod)
destroy(this.p_exit)
destroy(this.dw_ins)
destroy(this.rb_sub)
destroy(this.rb_pay)
destroy(this.dw_lst)
destroy(this.gb_1)
destroy(this.rr_1)
end on

event open;LsPaySubFlag = '1'

F_Window_Center_Response(This)

dw_ins.SetTransObject(Sqlca)
dw_ins.Reset()

dw_lst.SetTransObject(Sqlca)
dw_lst.Reset()
dw_lst.Retrieve(LsPaySubFlag)

IF dw_lst.RowCount() > 0 THEN
	dw_lst.SelectRow(0,False)
	dw_lst.SelectRow(1,True)
	
	Wf_Init_Ins()
END IF

ib_any_typing = False
end event

type p_mod from uo_picture within w_kifa32a
integer x = 3118
integer y = 24
integer width = 178
integer taborder = 20
string pointer = "C:\erpman\cur\update.cur"
string picturename = "C:\erpman\image\저장_up.gif"
end type

event clicked;call super::clicked;
IF dw_ins.AcceptText() = -1 THEN Return

IF ib_any_typing = True THEN
	IF f_dbConFirm('저장') = 2 THEN RETURN

	IF dw_ins.Update() = 1 THEN
		commit;
		
		dw_ins.SetFocus()
		
		ib_any_typing = False
	ELSE
		ROLLBACK;
		f_messagechk(13,'')
	END IF
END IF
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\저장_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\저장_up.gif"
end event

type p_exit from uo_picture within w_kifa32a
integer x = 3291
integer y = 24
integer width = 178
integer taborder = 30
string pointer = "C:\erpman\cur\close.cur"
string picturename = "C:\erpman\image\닫기_up.gif"
end type

event clicked;call super::clicked;
IF Ib_Any_Typing = True THEN
	If MessageBox('확 인','저장하지 않은 자료가 있습니다...저장하시겠습니까?',Question!,YesNo!) = 1 THEN 
		IF dw_ins.Update() <> 1 THEN
			ROLLBACK;
			f_messagechk(13,'')
			Return
		END IF
		Commit;
	END IF	
END IF

Close(w_kifa32a)
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\닫기_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\닫기_up.gif"
end event

type dw_ins from u_key_enter within w_kifa32a
event ue_key pbm_dwnkey
integer x = 914
integer y = 180
integer width = 2551
integer height = 1632
integer taborder = 10
string dataobject = "d_kifa32a2"
boolean border = false
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemchanged;String sAcCode,sBalGbn,sKwanNo,sNull

SetNull(sNull)

IF this.GetColumnName() = "accode1" THEN
	sAcCode = this.GetText()
	IF sAcCode = "" OR IsNull(sAcCode) THEN RETURN
	
	SELECT "KFZ01OM0"."BAL_GU"	INTO :sBalGbn
	  FROM "KFZ01OM0"  
	  WHERE "ACC1_CD" = substr(:sAcCode,1,5) AND "ACC2_CD" = substr(:sAcCode,6,2) ;
	If Sqlca.Sqlcode = 0 then
		IF sBalGbn = '4' THEN
			F_MessageChk(16,'[전표발행 불가]')
			this.Setitem(this.getrow(),"accode1",snull)
			Return 1
		END IF
	else
		f_messageChk(20,'[계정과목]')
		this.Setitem(this.getrow(),"accode1",snull)
		Return 1
	end if
END IF

IF this.GetColumnName() = "accode2" THEN
	sAcCode = this.GetText()
	IF sAcCode = "" OR IsNull(sAcCode) THEN RETURN
	
	SELECT "KFZ01OM0"."BAL_GU"	INTO :sBalGbn
	  FROM "KFZ01OM0"  
	  WHERE "ACC1_CD" = substr(:sAcCode,1,5) AND "ACC2_CD" = substr(:sAcCode,6,2) ;
	If Sqlca.Sqlcode = 0 then
		IF sBalGbn = '4' THEN
			F_MessageChk(16,'[전표발행 불가]')
			this.Setitem(this.getrow(),"accode2",snull)
			Return 1
		END IF
	else
		f_messageChk(20,'[계정과목]')
		this.Setitem(this.getrow(),"accode2",snull)
		Return 1
	end if
END IF

IF this.GetColumnName() = "accode3" THEN
	sAcCode = this.GetText()
	IF sAcCode = "" OR IsNull(sAcCode) THEN RETURN
	
	SELECT "KFZ01OM0"."BAL_GU"	INTO :sBalGbn
	  FROM "KFZ01OM0"  
	  WHERE "ACC1_CD" = substr(:sAcCode,1,5) AND "ACC2_CD" = substr(:sAcCode,6,2) ;
	If Sqlca.Sqlcode = 0 then
		IF sBalGbn = '4' THEN
			F_MessageChk(16,'[전표발행 불가]')
			this.Setitem(this.getrow(),"accode3",snull)
			Return 1
		END IF
	else
		f_messageChk(20,'[계정과목]')
		this.Setitem(this.getrow(),"accode3",snull)
		Return 1
	end if
END IF

IF this.GetColumnName() = "accode4" THEN
	sAcCode = this.GetText()
	IF sAcCode = "" OR IsNull(sAcCode) THEN RETURN
	
	SELECT "KFZ01OM0"."BAL_GU"	INTO :sBalGbn
	  FROM "KFZ01OM0"  
	  WHERE "ACC1_CD" = substr(:sAcCode,1,5) AND "ACC2_CD" = substr(:sAcCode,6,2) ;
	If Sqlca.Sqlcode = 0 then
		IF sBalGbn = '4' THEN
			F_MessageChk(16,'[전표발행 불가]')
			this.Setitem(this.getrow(),"accode4",snull)
			Return 1
		END IF
	else
		f_messageChk(20,'[계정과목]')
		this.Setitem(this.getrow(),"accode4",snull)
		Return 1
	end if
END IF

IF this.GetColumnName() = "accode5" THEN
	sAcCode = this.GetText()
	IF sAcCode = "" OR IsNull(sAcCode) THEN RETURN
	
	SELECT "KFZ01OM0"."BAL_GU"	INTO :sBalGbn
	  FROM "KFZ01OM0"  
	  WHERE "ACC1_CD" = substr(:sAcCode,1,5) AND "ACC2_CD" = substr(:sAcCode,6,2) ;
	If Sqlca.Sqlcode = 0 then
		IF sBalGbn = '4' THEN
			F_MessageChk(16,'[전표발행 불가]')
			this.Setitem(this.getrow(),"accode5",snull)
			Return 1
		END IF
	else
		f_messageChk(20,'[계정과목]')
		this.Setitem(this.getrow(),"accode5",snull)
		Return 1
	end if
END IF

IF this.GetColumnName() = "accode6" THEN
	sAcCode = this.GetText()
	IF sAcCode = "" OR IsNull(sAcCode) THEN RETURN
	
	SELECT "KFZ01OM0"."BAL_GU"	INTO :sBalGbn
	  FROM "KFZ01OM0"  
	  WHERE "ACC1_CD" = substr(:sAcCode,1,5) AND "ACC2_CD" = substr(:sAcCode,6,2) ;
	If Sqlca.Sqlcode = 0 then
		IF sBalGbn = '4' THEN
			F_MessageChk(16,'[전표발행 불가]')
			this.Setitem(this.getrow(),"accode6",snull)
			Return 1
		END IF
	else
		f_messageChk(20,'[계정과목]')
		this.Setitem(this.getrow(),"accode6",snull)
		Return 1
	end if
END IF

IF this.GetColumnName() = "accode7" THEN
	sAcCode = this.GetText()
	IF sAcCode = "" OR IsNull(sAcCode) THEN RETURN
	
	SELECT "KFZ01OM0"."BAL_GU"	INTO :sBalGbn
	  FROM "KFZ01OM0"  
	  WHERE "ACC1_CD" = substr(:sAcCode,1,5) AND "ACC2_CD" = substr(:sAcCode,6,2) ;
	If Sqlca.Sqlcode = 0 then
		IF sBalGbn = '4' THEN
			F_MessageChk(16,'[전표발행 불가]')
			this.Setitem(this.getrow(),"accode7",snull)
			Return 1
		END IF
	else
		f_messageChk(20,'[계정과목]')
		this.Setitem(this.getrow(),"accode7",snull)
		Return 1
	end if
END IF

IF this.GetColumnName() = "accode8" THEN
	sAcCode = this.GetText()
	IF sAcCode = "" OR IsNull(sAcCode) THEN RETURN
	
	SELECT "KFZ01OM0"."BAL_GU"	INTO :sBalGbn
	  FROM "KFZ01OM0"  
	  WHERE "ACC1_CD" = substr(:sAcCode,1,5) AND "ACC2_CD" = substr(:sAcCode,6,2) ;
	If Sqlca.Sqlcode = 0 then
		IF sBalGbn = '4' THEN
			F_MessageChk(16,'[전표발행 불가]')
			this.Setitem(this.getrow(),"accode8",snull)
			Return 1
		END IF
	else
		f_messageChk(20,'[계정과목]')
		this.Setitem(this.getrow(),"accode8",snull)
		Return 1
	end if
END IF

IF this.GetColumnName() = "accode9" THEN
	sAcCode = this.GetText()
	IF sAcCode = "" OR IsNull(sAcCode) THEN RETURN
	
	SELECT "KFZ01OM0"."BAL_GU"	INTO :sBalGbn
	  FROM "KFZ01OM0"  
	  WHERE "ACC1_CD" = substr(:sAcCode,1,5) AND "ACC2_CD" = substr(:sAcCode,6,2) ;
	If Sqlca.Sqlcode = 0 then
		IF sBalGbn = '4' THEN
			F_MessageChk(16,'[전표발행 불가]')
			this.Setitem(this.getrow(),"accode9",snull)
			Return 1
		END IF
	else
		f_messageChk(20,'[계정과목]')
		this.Setitem(this.getrow(),"accode9",snull)
		Return 1
	end if
END IF

IF this.GetColumnName() = "accode10" THEN
	sAcCode = this.GetText()
	IF sAcCode = "" OR IsNull(sAcCode) THEN RETURN
	
	SELECT "KFZ01OM0"."BAL_GU"	INTO :sBalGbn
	  FROM "KFZ01OM0"  
	  WHERE "ACC1_CD" = substr(:sAcCode,1,5) AND "ACC2_CD" = substr(:sAcCode,6,2) ;
	If Sqlca.Sqlcode = 0 then
		IF sBalGbn = '4' THEN
			F_MessageChk(16,'[전표발행 불가]')
			this.Setitem(this.getrow(),"accode10",snull)
			Return 1
		END IF
	else
		f_messageChk(20,'[계정과목]')
		this.Setitem(this.getrow(),"accode10",snull)
		Return 1
	end if
END IF

IF this.GetColumnName() = "accode11" THEN
	sAcCode = this.GetText()
	IF sAcCode = "" OR IsNull(sAcCode) THEN RETURN
	
	SELECT "KFZ01OM0"."BAL_GU"	INTO :sBalGbn
	  FROM "KFZ01OM0"  
	  WHERE "ACC1_CD" = substr(:sAcCode,1,5) AND "ACC2_CD" = substr(:sAcCode,6,2) ;
	If Sqlca.Sqlcode = 0 then
		IF sBalGbn = '4' THEN
			F_MessageChk(16,'[전표발행 불가]')
			this.Setitem(this.getrow(),"accode11",snull)
			Return 1
		END IF
	else
		f_messageChk(20,'[계정과목]')
		this.Setitem(this.getrow(),"accode11",snull)
		Return 1
	end if
END IF

IF this.GetColumnName() = "accode12" THEN
	sAcCode = this.GetText()
	IF sAcCode = "" OR IsNull(sAcCode) THEN RETURN
	
	SELECT "KFZ01OM0"."BAL_GU"	INTO :sBalGbn
	  FROM "KFZ01OM0"  
	  WHERE "ACC1_CD" = substr(:sAcCode,1,5) AND "ACC2_CD" = substr(:sAcCode,6,2) ;
	If Sqlca.Sqlcode = 0 then
		IF sBalGbn = '4' THEN
			F_MessageChk(16,'[전표발행 불가]')
			this.Setitem(this.getrow(),"accode12",snull)
			Return 1
		END IF
	else
		f_messageChk(20,'[계정과목]')
		this.Setitem(this.getrow(),"accode12",snull)
		Return 1
	end if
END IF

IF this.GetColumnName() = "accode13" THEN
	sAcCode = this.GetText()
	IF sAcCode = "" OR IsNull(sAcCode) THEN RETURN
	
	SELECT "KFZ01OM0"."BAL_GU"	INTO :sBalGbn
	  FROM "KFZ01OM0"  
	  WHERE "ACC1_CD" = substr(:sAcCode,1,5) AND "ACC2_CD" = substr(:sAcCode,6,2) ;
	If Sqlca.Sqlcode = 0 then
		IF sBalGbn = '4' THEN
			F_MessageChk(16,'[전표발행 불가]')
			this.Setitem(this.getrow(),"accode13",snull)
			Return 1
		END IF
	else
		f_messageChk(20,'[계정과목]')
		this.Setitem(this.getrow(),"accode13",snull)
		Return 1
	end if
END IF

IF this.GetColumnName() = "accode14" THEN
	sAcCode = this.GetText()
	IF sAcCode = "" OR IsNull(sAcCode) THEN RETURN
	
	SELECT "KFZ01OM0"."BAL_GU"	INTO :sBalGbn
	  FROM "KFZ01OM0"  
	  WHERE "ACC1_CD" = substr(:sAcCode,1,5) AND "ACC2_CD" = substr(:sAcCode,6,2) ;
	If Sqlca.Sqlcode = 0 then
		IF sBalGbn = '4' THEN
			F_MessageChk(16,'[전표발행 불가]')
			this.Setitem(this.getrow(),"accode14",snull)
			Return 1
		END IF
	else
		f_messageChk(20,'[계정과목]')
		this.Setitem(this.getrow(),"accode14",snull)
		Return 1
	end if
END IF

IF this.GetColumnName() = "accode15" THEN
	sAcCode = this.GetText()
	IF sAcCode = "" OR IsNull(sAcCode) THEN RETURN
	
	SELECT "KFZ01OM0"."BAL_GU"	INTO :sBalGbn
	  FROM "KFZ01OM0"  
	  WHERE "ACC1_CD" = substr(:sAcCode,1,5) AND "ACC2_CD" = substr(:sAcCode,6,2) ;
	If Sqlca.Sqlcode = 0 then
		IF sBalGbn = '4' THEN
			F_MessageChk(16,'[전표발행 불가]')
			this.Setitem(this.getrow(),"accode15",snull)
			Return 1
		END IF
	else
		f_messageChk(20,'[계정과목]')
		this.Setitem(this.getrow(),"accode15",snull)
		Return 1
	end if
END IF

IF this.GetColumnName() = "accode16" THEN
	sAcCode = this.GetText()
	IF sAcCode = "" OR IsNull(sAcCode) THEN RETURN
	
	SELECT "KFZ01OM0"."BAL_GU"	INTO :sBalGbn
	  FROM "KFZ01OM0"  
	  WHERE "ACC1_CD" = substr(:sAcCode,1,5) AND "ACC2_CD" = substr(:sAcCode,6,2) ;
	If Sqlca.Sqlcode = 0 then
		IF sBalGbn = '4' THEN
			F_MessageChk(16,'[전표발행 불가]')
			this.Setitem(this.getrow(),"accode16",snull)
			Return 1
		END IF
	else
		f_messageChk(20,'[계정과목]')
		this.Setitem(this.getrow(),"accode16",snull)
		Return 1
	end if
END IF
IF this.GetColumnName() = "accode17" THEN
	sAcCode = this.GetText()
	IF sAcCode = "" OR IsNull(sAcCode) THEN RETURN
	
	SELECT "KFZ01OM0"."BAL_GU"	INTO :sBalGbn
	  FROM "KFZ01OM0"  
	  WHERE "ACC1_CD" = substr(:sAcCode,1,5) AND "ACC2_CD" = substr(:sAcCode,6,2) ;
	If Sqlca.Sqlcode = 0 then
		IF sBalGbn = '4' THEN
			F_MessageChk(16,'[전표발행 불가]')
			this.Setitem(this.getrow(),"accode17",snull)
			Return 1
		END IF
	else
		f_messageChk(20,'[계정과목]')
		this.Setitem(this.getrow(),"accode17",snull)
		Return 1
	end if
END IF
IF this.GetColumnName() = "accode18" THEN
	sAcCode = this.GetText()
	IF sAcCode = "" OR IsNull(sAcCode) THEN RETURN
	
	SELECT "KFZ01OM0"."BAL_GU"	INTO :sBalGbn
	  FROM "KFZ01OM0"  
	  WHERE "ACC1_CD" = substr(:sAcCode,1,5) AND "ACC2_CD" = substr(:sAcCode,6,2) ;
	If Sqlca.Sqlcode = 0 then
		IF sBalGbn = '4' THEN
			F_MessageChk(16,'[전표발행 불가]')
			this.Setitem(this.getrow(),"accode18",snull)
			Return 1
		END IF
	else
		f_messageChk(20,'[계정과목]')
		this.Setitem(this.getrow(),"accode18",snull)
		Return 1
	end if
END IF
IF this.GetColumnName() = "accode19" THEN
	sAcCode = this.GetText()
	IF sAcCode = "" OR IsNull(sAcCode) THEN RETURN
	
	SELECT "KFZ01OM0"."BAL_GU"	INTO :sBalGbn
	  FROM "KFZ01OM0"  
	  WHERE "ACC1_CD" = substr(:sAcCode,1,5) AND "ACC2_CD" = substr(:sAcCode,6,2) ;
	If Sqlca.Sqlcode = 0 then
		IF sBalGbn = '4' THEN
			F_MessageChk(16,'[전표발행 불가]')
			this.Setitem(this.getrow(),"accode19",snull)
			Return 1
		END IF
	else
		f_messageChk(20,'[계정과목]')
		this.Setitem(this.getrow(),"accode19",snull)
		Return 1
	end if
END IF

IF this.GetColumnName() = "accode19_kwan" THEN
	sKwanNo = this.GetText()
	IF sKwanNo = "" OR IsNull(sKwanNo) THEN RETURN
	
	SELECT "PERSON_NO"	INTO :sKwanNo
	  FROM "KFZ04OM0"  
	  WHERE "PERSON_CD" = :sKwanNo AND "PERSON_GU" = '1' ;
	If Sqlca.Sqlcode <> 0 then
		f_messageChk(20,'[구분]')
		this.Setitem(this.getrow(),"accode19_kwan",snull)
		Return 1
	end if
END IF

IF this.GetColumnName() = "accode21" THEN
	sAcCode = this.GetText()
	IF sAcCode = "" OR IsNull(sAcCode) THEN RETURN
	
	SELECT "KFZ01OM0"."BAL_GU"	INTO :sBalGbn
	  FROM "KFZ01OM0"  
	  WHERE "ACC1_CD" = substr(:sAcCode,1,5) AND "ACC2_CD" = substr(:sAcCode,6,2) ;
	If Sqlca.Sqlcode = 0 then
		IF sBalGbn = '4' THEN
			F_MessageChk(16,'[전표발행 불가]')
			this.Setitem(this.getrow(),"accode21",snull)
			Return 1
		END IF
	else
		f_messageChk(20,'[계정과목]')
		this.Setitem(this.getrow(),"accode21",snull)
		Return 1
	end if
END IF

IF this.GetColumnName() = "accode22" THEN
	sAcCode = this.GetText()
	IF sAcCode = "" OR IsNull(sAcCode) THEN RETURN
	
	SELECT "KFZ01OM0"."BAL_GU"	INTO :sBalGbn
	  FROM "KFZ01OM0"  
	  WHERE "ACC1_CD" = substr(:sAcCode,1,5) AND "ACC2_CD" = substr(:sAcCode,6,2) ;
	If Sqlca.Sqlcode = 0 then
		IF sBalGbn = '4' THEN
			F_MessageChk(16,'[전표발행 불가]')
			this.Setitem(this.getrow(),"accode22",snull)
			Return 1
		END IF
	else
		f_messageChk(20,'[계정과목]')
		this.Setitem(this.getrow(),"accode22",snull)
		Return 1
	end if
END IF

IF this.GetColumnName() = "accode23" THEN
	sAcCode = this.GetText()
	IF sAcCode = "" OR IsNull(sAcCode) THEN RETURN
	
	SELECT "KFZ01OM0"."BAL_GU"	INTO :sBalGbn
	  FROM "KFZ01OM0"  
	  WHERE "ACC1_CD" = substr(:sAcCode,1,5) AND "ACC2_CD" = substr(:sAcCode,6,2) ;
	If Sqlca.Sqlcode = 0 then
		IF sBalGbn = '4' THEN
			F_MessageChk(16,'[전표발행 불가]')
			this.Setitem(this.getrow(),"accode23",snull)
			Return 1
		END IF
	else
		f_messageChk(20,'[계정과목]')
		this.Setitem(this.getrow(),"accode23",snull)
		Return 1
	end if
END IF

IF this.GetColumnName() = "accode24" THEN
	sAcCode = this.GetText()
	IF sAcCode = "" OR IsNull(sAcCode) THEN RETURN
	
	SELECT "KFZ01OM0"."BAL_GU"	INTO :sBalGbn
	  FROM "KFZ01OM0"  
	  WHERE "ACC1_CD" = substr(:sAcCode,1,5) AND "ACC2_CD" = substr(:sAcCode,6,2) ;
	If Sqlca.Sqlcode = 0 then
		IF sBalGbn = '4' THEN
			F_MessageChk(16,'[전표발행 불가]')
			this.Setitem(this.getrow(),"accode24",snull)
			Return 1
		END IF
	else
		f_messageChk(20,'[계정과목]')
		this.Setitem(this.getrow(),"accode24",snull)
		Return 1
	end if
END IF

IF this.GetColumnName() = "accode25" THEN
	sAcCode = this.GetText()
	IF sAcCode = "" OR IsNull(sAcCode) THEN RETURN
	
	SELECT "KFZ01OM0"."BAL_GU"	INTO :sBalGbn
	  FROM "KFZ01OM0"  
	  WHERE "ACC1_CD" = substr(:sAcCode,1,5) AND "ACC2_CD" = substr(:sAcCode,6,2) ;
	If Sqlca.Sqlcode = 0 then
		IF sBalGbn = '4' THEN
			F_MessageChk(16,'[전표발행 불가]')
			this.Setitem(this.getrow(),"accode25",snull)
			Return 1
		END IF
	else
		f_messageChk(20,'[계정과목]')
		this.Setitem(this.getrow(),"accode25",snull)
		Return 1
	end if
END IF

IF this.GetColumnName() = "accode26" THEN
	sAcCode = this.GetText()
	IF sAcCode = "" OR IsNull(sAcCode) THEN RETURN
	
	SELECT "KFZ01OM0"."BAL_GU"	INTO :sBalGbn
	  FROM "KFZ01OM0"  
	  WHERE "ACC1_CD" = substr(:sAcCode,1,5) AND "ACC2_CD" = substr(:sAcCode,6,2) ;
	If Sqlca.Sqlcode = 0 then
		IF sBalGbn = '4' THEN
			F_MessageChk(16,'[전표발행 불가]')
			this.Setitem(this.getrow(),"accode26",snull)
			Return 1
		END IF
	else
		f_messageChk(20,'[계정과목]')
		this.Setitem(this.getrow(),"accode26",snull)
		Return 1
	end if
END IF

ib_any_typing = True

end event

event editchanged;ib_any_typing = True
end event

event itemerror;Return 1
end event

event getfocus;this.AcceptText()
end event

event rbuttondown;
if this.GetColumnName() = 'accode19_kwan' then
	SetNull(lstr_custom.code);		SetNull(lstr_custom.name);
	
	OpenWithParm(W_KFZ04OM0_POPUP,'1')
	
	IF IsNull(lstr_custom.code) OR lstr_custom.code = '' THEN Return
	
	this.SetItem(this.GetRow(),"accode19_kwan", lstr_custom.code)
	
else
	SetNull(lstr_account.acc1_cd);	SetNull(lstr_account.acc2_cd);
	
	Open(W_KFZ01OM0_POPUP)
	
	IF IsNull(lstr_account.acc1_cd) AND IsNull(lstr_account.acc2_cd) THEN Return
	
	IF this.GetColumnName() ="accode1" THEN
		this.SetItem(this.GetRow(),"accode1",lstr_account.acc1_cd+lstr_account.acc2_cd)
	ELSEIF this.GetColumnName() ="accode2" THEN
		this.SetItem(this.GetRow(),"accode2",lstr_account.acc1_cd+lstr_account.acc2_cd)
	ELSEIF this.GetColumnName() ="accode3" THEN
		this.SetItem(this.GetRow(),"accode3",lstr_account.acc1_cd+lstr_account.acc2_cd)
	ELSEIF this.GetColumnName() ="accode4" THEN
		this.SetItem(this.GetRow(),"accode4",lstr_account.acc1_cd+lstr_account.acc2_cd)
	ELSEIF this.GetColumnName() ="accode5" THEN
		this.SetItem(this.GetRow(),"accode5",lstr_account.acc1_cd+lstr_account.acc2_cd)
	ELSEIF this.GetColumnName() ="accode6" THEN
		this.SetItem(this.GetRow(),"accode6",lstr_account.acc1_cd+lstr_account.acc2_cd)
	ELSEIF this.GetColumnName() ="accode7" THEN
		this.SetItem(this.GetRow(),"accode7",lstr_account.acc1_cd+lstr_account.acc2_cd)
	ELSEIF this.GetColumnName() ="accode8" THEN
		this.SetItem(this.GetRow(),"accode8",lstr_account.acc1_cd+lstr_account.acc2_cd)
	ELSEIF this.GetColumnName() ="accode9" THEN
		this.SetItem(this.GetRow(),"accode9",lstr_account.acc1_cd+lstr_account.acc2_cd)
	ELSEIF this.GetColumnName() ="accode10" THEN
		this.SetItem(this.GetRow(),"accode10",lstr_account.acc1_cd+lstr_account.acc2_cd)
	ELSEIF this.GetColumnName() ="accode11" THEN
		this.SetItem(this.GetRow(),"accode11",lstr_account.acc1_cd+lstr_account.acc2_cd)
	ELSEIF this.GetColumnName() ="accode12" THEN
		this.SetItem(this.GetRow(),"accode12",lstr_account.acc1_cd+lstr_account.acc2_cd)
	ELSEIF this.GetColumnName() ="accode13" THEN
		this.SetItem(this.GetRow(),"accode13",lstr_account.acc1_cd+lstr_account.acc2_cd)
	ELSEIF this.GetColumnName() ="accode14" THEN
		this.SetItem(this.GetRow(),"accode14",lstr_account.acc1_cd+lstr_account.acc2_cd)
	ELSEIF this.GetColumnName() ="accode15" THEN
		this.SetItem(this.GetRow(),"accode15",lstr_account.acc1_cd+lstr_account.acc2_cd)
	ELSEIF this.GetColumnName() ="accode16" THEN
		this.SetItem(this.GetRow(),"accode16",lstr_account.acc1_cd+lstr_account.acc2_cd)
	ELSEIF this.GetColumnName() ="accode17" THEN
		this.SetItem(this.GetRow(),"accode17",lstr_account.acc1_cd+lstr_account.acc2_cd)
	ELSEIF this.GetColumnName() ="accode18" THEN
		this.SetItem(this.GetRow(),"accode18",lstr_account.acc1_cd+lstr_account.acc2_cd)
	ELSEIF this.GetColumnName() ="accode19" THEN
		this.SetItem(this.GetRow(),"accode19",lstr_account.acc1_cd+lstr_account.acc2_cd)
	ELSEIF this.GetColumnName() ="accode21" THEN
		this.SetItem(this.GetRow(),"accode21",lstr_account.acc1_cd+lstr_account.acc2_cd)	
	ELSEIF this.GetColumnName() ="accode22" THEN
		this.SetItem(this.GetRow(),"accode22",lstr_account.acc1_cd+lstr_account.acc2_cd)	
	ELSEIF this.GetColumnName() ="accode23" THEN
		this.SetItem(this.GetRow(),"accode23",lstr_account.acc1_cd+lstr_account.acc2_cd)	
	ELSEIF this.GetColumnName() ="accode24" THEN
		this.SetItem(this.GetRow(),"accode24",lstr_account.acc1_cd+lstr_account.acc2_cd)	
	ELSEIF this.GetColumnName() ="accode25" THEN
		this.SetItem(this.GetRow(),"accode25",lstr_account.acc1_cd+lstr_account.acc2_cd)	
	ELSEIF this.GetColumnName() ="accode26" THEN
		this.SetItem(this.GetRow(),"accode26",lstr_account.acc1_cd+lstr_account.acc2_cd)	
	END IF
end if
this.TriggerEvent(ItemChanged!)


end event

type rb_sub from radiobutton within w_kifa32a
integer x = 498
integer y = 68
integer width = 247
integer height = 76
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "공제"
borderstyle borderstyle = stylelowered!
end type

event clicked;LsPaySubFlag ='2'

dw_lst.Retrieve(LsPaySubFlag)

IF dw_lst.RowCount() > 0 THEN
	dw_lst.SelectRow(0,False)
	dw_lst.SelectRow(1,True)
	
	Wf_Init_Ins()
END IF
ib_any_typing = False
end event

type rb_pay from radiobutton within w_kifa32a
integer x = 151
integer y = 68
integer width = 247
integer height = 76
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "지급"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

event clicked;LsPaySubFlag ='1'

dw_lst.Retrieve(LsPaySubFlag)

IF dw_lst.RowCount() > 0 THEN
	dw_lst.SelectRow(0,False)
	dw_lst.SelectRow(1,True)
	
	Wf_Init_Ins()
END IF
ib_any_typing = False
end event

type dw_lst from datawindow within w_kifa32a
integer x = 46
integer y = 188
integer width = 809
integer height = 1604
string dataobject = "d_kifa32a1"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event clicked;
IF row <=0 THEN Return

SelectRow(0,False)
SelectRow(Row,True)

Wf_Init_Ins()
end event

event rowfocuschanged;IF currentrow <=0 THEN Return

SelectRow(0,False)
SelectRow(currentrow,True)

Wf_Init_Ins()
end event

type gb_1 from groupbox within w_kifa32a
integer x = 27
integer y = 4
integer width = 846
integer height = 164
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "지급/공제 구분"
borderstyle borderstyle = stylelowered!
end type

type rr_1 from roundrectangle within w_kifa32a
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 32
integer y = 180
integer width = 841
integer height = 1620
integer cornerheight = 40
integer cornerwidth = 55
end type

