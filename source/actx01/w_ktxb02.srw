$PBExportHeader$w_ktxb02.srw
$PBExportComments$접대비시부인계산명세서 조회출력
forward
global type w_ktxb02 from w_standard_print
end type
type rr_1 from roundrectangle within w_ktxb02
end type
end forward

global type w_ktxb02 from w_standard_print
integer x = 0
integer y = 0
string title = "접대비 시부인계산명세서 조회출력"
rr_1 rr_1
end type
global w_ktxb02 w_ktxb02

type variables
string lsacc1_cd,lsacc2_cd,ltacc1_cd,ltacc2_cd
end variables

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String syy,smm,sdd,symd_text,styy,stmm,stdd,stymd_text
String ssdate,stdate, srat, ssuip
long   lhando,lsuip,lrat

dw_ip.AcceptText()

ssdate = Trim(dw_ip.GetItemString(1,"symd"))
stdate = Trim(dw_ip.GetItemString(1,"tymd"))
lhando = dw_ip.GetItemNumber(1,"hando")
lsuip  = dw_ip.GetItemNumber(1,"suip")
lrat   = dw_ip.GetItemNumber(1,"rat")
srat 	 = string(lrat, '0.0')
ssuip  = string(lsuip, '0,000')

IF ssdate = "" OR IsNull(ssdate) THEN
	F_MessageChk(1,'[사용기간]')
	dw_ip.SetColumn("symd")
	dw_ip.SetFocus()
	Return -1
ELSE
	IF f_datechk(ssdate) = -1 THEN
		f_messagechk(23, "")
		dw_ip.SetColumn("symd")
		dw_ip.SetFocus()
		Return -1
	END IF
END IF

IF stdate = "" OR IsNull(stdate) THEN
	F_MessageChk(1,'[사용기간]')
	dw_ip.SetColumn("tymd")
	dw_ip.SetFocus()
	Return -1
ELSE
	IF f_datechk(stdate) = -1 THEN
		f_messagechk(23, "")
		dw_ip.SetColumn("tymd")
		dw_ip.SetFocus()
		Return -1
	END IF
END IF

IF lhando = 0 OR IsNull(lhando) THEN
	F_MessageChk(1,'[한도기준]')
	dw_ip.SetColumn("hando")
	dw_ip.SetFocus()
	Return -1
END IF
IF IsNull(lsuip) THEN
	lsuip = 0
END IF
IF lrat = 0 OR IsNull(lrat) THEN
	F_MessageChk(1,'[사용비율]')
	dw_ip.SetColumn("rat")
	dw_ip.SetFocus()
	Return -1
END IF

syy = left(ssdate, 4)
smm = mid(ssdate,5,2)
sdd = right(ssdate,2)
symd_text = syy + '.'+ smm + '.' + sdd

styy = left(stdate, 4)
stmm = mid(stdate,5,2)
stdd = right(stdate,2)
stymd_text = styy + '.'+ stmm + '.' + stdd

dw_list.modify("symd.text ='"+symd_text+"'")
dw_list.modify("stymd.text ='"+stymd_text+"'")
dw_list.modify("lrat.text ='"+srat+"'")
dw_list.modify("lsuip.text ='"+ssuip+"'")

setpointer(hourglass!)

if dw_print.retrieve(ssdate,stdate,lhando,lsuip,lrat,lsacc1_cd,lsacc2_cd,ltacc1_cd,ltacc2_cd) <= 0 then
	messagebox("확인","조회한 자료가 없습니다.!!") 
	//return -1
	dw_list.insertrow(0)
end if 
	dw_print.sharedata(dw_list)

dw_ip.SetFocus()
setpointer(arrow!)

Return 1


end function

on w_ktxb02.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_ktxb02.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;string sFrymd,sToymd

select substr(dataname,1,5),
       substr(dataname,6,2),
       substr(dataname,8,5),
       substr(dataname,13,2)
  into :lsacc1_cd,:lsacc2_cd,:ltacc1_cd,:ltacc2_cd
  from syscnfg
 where sysgu = 'A'
   and serial = 2
	and lineno = 'D'
	and datagu = 1;

select d_frymd,d_toymd 
  into :sFrymd,:sToymd
  from kfz08om0
 where rownum = 1;

dw_ip.SetItem(dw_ip.Getrow(),"symd",sFrymd)
dw_ip.SetItem(dw_ip.Getrow(),"tymd",sToymd)
//dw_ip.SetItem(dw_ip.Getrow(),"acc_date",String(today(),"yyyymmdd"))
dw_ip.SetFocus()

end event

type p_preview from w_standard_print`p_preview within w_ktxb02
end type

type p_exit from w_standard_print`p_exit within w_ktxb02
end type

type p_print from w_standard_print`p_print within w_ktxb02
end type

type p_retrieve from w_standard_print`p_retrieve within w_ktxb02
end type







type st_10 from w_standard_print`st_10 within w_ktxb02
end type



type dw_print from w_standard_print`dw_print within w_ktxb02
string dataobject = "dw_ktxb021_p"
end type

type dw_ip from w_standard_print`dw_ip within w_ktxb02
integer x = 46
integer width = 2647
integer height = 308
string dataobject = "dw_ktxb02"
end type

type dw_list from w_standard_print`dw_list within w_ktxb02
integer x = 64
integer y = 336
integer width = 4517
integer height = 1968
string dataobject = "dw_ktxb021"
boolean border = false
end type

type rr_1 from roundrectangle within w_ktxb02
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 50
integer y = 324
integer width = 4549
integer height = 1996
integer cornerheight = 40
integer cornerwidth = 55
end type

