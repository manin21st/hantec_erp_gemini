$PBExportHeader$w_qct_06500.srw
$PBExportComments$** 품질동향
forward
global type w_qct_06500 from w_standard_print
end type
type dw_rate from u_key_enter within w_qct_06500
end type
type p_mod from uo_picture within w_qct_06500
end type
type rr_1 from roundrectangle within w_qct_06500
end type
type rr_2 from roundrectangle within w_qct_06500
end type
end forward

global type w_qct_06500 from w_standard_print
string title = "품질동향"
dw_rate dw_rate
p_mod p_mod
rr_1 rr_1
rr_2 rr_2
end type
global w_qct_06500 w_qct_06500

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string ym, gbn, ym3, junyy, ym4, ym5

if dw_ip.AcceptText() = -1 then
	dw_ip.SetFocus()
	return -1
end if	

ym = Trim(dw_ip.object.ym[1])
gbn = Trim(dw_ip.object.gbn[1])

if (IsNull(ym) or ym = "")  then 
	f_message_chk(30, "[기준년월]")
	dw_ip.SetColumn("ym")
	dw_ip.Setfocus()
	return -1
end if

junyy = Mid(f_aftermonth(ym, -12),1,4)

// 당월 기준으로 6개월 이전의 년월을 검색
ym3 = f_aftermonth(ym, -5)

// 전년도 의 당월과 6개월 이전의 년월을 검색
ym4 = f_aftermonth(ym, -12)
ym5 = f_aftermonth(ym4, -5)

//dw_list.object.txt_title.text = String(ym,"@@@@년 @@월 품질동향")
//
////dw_list.object.txt_inrate.text = String(dw_rate.object.inrate[1], "##0.00")
////dw_list.object.txt_gongrate.text = String(dw_rate.object.gongrate[1], "##0.00")
////dw_list.object.txt_outrate.text = String(dw_rate.object.outrate[1], "##0.00")
////dw_list.object.txt_asrate.text = String(dw_rate.object.asrate[1], "##0.00")
//
if dw_list.Retrieve(gs_sabu, gbn, ym, Mid(ym,1,4), junyy, ym+'99', ym3, ym4, ym5) <= 0 then
	f_message_chk(50,'[품질동향]')
	dw_ip.Setfocus()
//	return -1
end if

//IF dw_print.Retrieve(gs_sabu, gbn, ym, Mid(ym,1,4), junyy, ym+'99', ym3, ym4, ym5) <= 0 then
//	f_message_chk(50,'[품질동향]')
//	dw_list.Reset()
//	dw_ip.SetFocus()
//   dw_list.SetRedraw(true)
//	dw_print.insertrow(0)
////	Return -1
//END IF

dw_print.Retrieve(gs_sabu, gbn, ym, Mid(ym,1,4), junyy, ym+'99', ym3, ym4, ym5)
//dw_print.object.txt_title.text = String(ym,"@@@@년 @@월 품질동향")

//dw_print.ShareData(dw_list)

return 1

end function

on w_qct_06500.create
int iCurrent
call super::create
this.dw_rate=create dw_rate
this.p_mod=create p_mod
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_rate
this.Control[iCurrent+2]=this.p_mod
this.Control[iCurrent+3]=this.rr_1
this.Control[iCurrent+4]=this.rr_2
end on

on w_qct_06500.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_rate)
destroy(this.p_mod)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event w_qct_06500::open;call super::open;dw_ip.SetItem(1,"ym", Left(F_Today(),6))
dw_ip.SetFocus()

dw_rate.SetTransObject(SQLCA)
dw_rate.Visible = False
end event

type p_preview from w_standard_print`p_preview within w_qct_06500
integer x = 4037
integer taborder = 50
end type

type p_exit from w_standard_print`p_exit within w_qct_06500
integer x = 4384
integer taborder = 70
end type

type p_print from w_standard_print`p_print within w_qct_06500
integer x = 4210
integer taborder = 60
end type

type p_retrieve from w_standard_print`p_retrieve within w_qct_06500
integer x = 3863
integer taborder = 40
end type







type st_10 from w_standard_print`st_10 within w_qct_06500
end type



type dw_print from w_standard_print`dw_print within w_qct_06500
integer x = 3502
integer y = 44
integer width = 183
integer height = 140
string dataobject = "d_qct_06500_02_p"
end type

type dw_ip from w_standard_print`dw_ip within w_qct_06500
integer x = 219
integer y = 52
integer width = 1115
integer height = 220
string dataobject = "d_qct_06500_01"
end type

event dw_ip::itemchanged;string s_cod

s_cod = Trim(this.GetText())

if this.GetColumnName() = "ym" then
	if f_datechk(s_cod + '01') = -1 then
		f_message_chk(35, "[기준년월]")
		this.object.ym[1] = ""
		dw_rate.Visible = False
		return 1
	else
	   dw_rate.Visible = True
		if dw_rate.Retrieve(Mid(s_cod,1,4)) < 1 then
			dw_rate.InsertRow(0)
			dw_rate.object.yyyy[1] = Mid(s_cod,1,4)
		else
			dw_ip.SetFocus()
		end if	
		
	end if
end if


end event

event dw_ip::itemerror;return 1
end event

type dw_list from w_standard_print`dw_list within w_qct_06500
integer x = 59
integer width = 4498
integer height = 1928
string dataobject = "d_qct_06500_02"
boolean border = false
end type

type dw_rate from u_key_enter within w_qct_06500
integer x = 1321
integer y = 132
integer width = 2144
integer height = 144
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_qct_06500_03"
boolean border = false
end type

event itemerror;call super::itemerror;return 1
end event

type p_mod from uo_picture within w_qct_06500
integer x = 3689
integer y = 24
integer width = 178
integer taborder = 30
boolean bringtotop = true
string pointer = "c:\erpman\cur\update.cur"
boolean originalsize = true
string picturename = "C:\erpman\image\저장_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\저장_dn.gif'
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\저장_up.gif'
end event

event clicked;call super::clicked;if dw_rate.AcceptText() = -1 then 
   sle_msg.text = "자료를 정확하게 입력하세요!"	
	return -1
end if

if dw_rate.Update() = -1 then
	rollback;
	sle_msg.text = "자료 입력 실패!"	
	return -1
else
	commit;
	sle_msg.text = "자료 입력 완료!"	
end if	
	
end event

type rr_1 from roundrectangle within w_qct_06500
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 206
integer y = 32
integer width = 3291
integer height = 264
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_qct_06500
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 50
integer y = 332
integer width = 4535
integer height = 1944
integer cornerheight = 40
integer cornerwidth = 55
end type

