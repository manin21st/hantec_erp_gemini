$PBExportHeader$w_pdt_06044_image.srw
$PBExportComments$수리 전/후 사진 등록
forward
global type w_pdt_06044_image from w_inherite_popup
end type
type p_1 from picture within w_pdt_06044_image
end type
type p_2 from picture within w_pdt_06044_image
end type
type p_3 from picture within w_pdt_06044_image
end type
type p_4 from picture within w_pdt_06044_image
end type
type p_img1 from picture within w_pdt_06044_image
end type
type p_img2 from picture within w_pdt_06044_image
end type
type st_2 from statictext within w_pdt_06044_image
end type
type st_3 from statictext within w_pdt_06044_image
end type
type p_img_del1 from picture within w_pdt_06044_image
end type
type p_img_add1 from picture within w_pdt_06044_image
end type
type p_img_add2 from picture within w_pdt_06044_image
end type
type p_img_del2 from picture within w_pdt_06044_image
end type
type rr_1 from roundrectangle within w_pdt_06044_image
end type
type rr_2 from roundrectangle within w_pdt_06044_image
end type
end forward

global type w_pdt_06044_image from w_inherite_popup
integer width = 3259
integer height = 1908
string title = "설비수리 전/후 사진 등록"
event ue_open ( )
p_1 p_1
p_2 p_2
p_3 p_3
p_4 p_4
p_img1 p_img1
p_img2 p_img2
st_2 st_2
st_3 st_3
p_img_del1 p_img_del1
p_img_add1 p_img_add1
p_img_add2 p_img_add2
p_img_del2 p_img_del2
rr_1 rr_1
rr_2 rr_2
end type
global w_pdt_06044_image w_pdt_06044_image

type variables
blob		iblob_IMG1, iblob_IMG2
string		is_sidat, is_gubun, is_mchno
integer	ii_seq

end variables
forward prototypes
public function integer wf_load_image ()
end prototypes

event ue_open();//dw_1.SetRedraw(False)
//dw_1.Retrieve(istr_str.as_str[1], istr_str.as_str[2], istr_str.as_str[3], istr_str.as_str[4], istr_str.as_str[5])
//dw_1.SetRedraw(True)
end event

public function integer wf_load_image ();//string	sMchNo
//int 		iCnt
//blob		lblobBMP
//
//p_img.Visible = False
//
//sMchNo = dw_insert.getitemstring(1,"mchno")
/////////////////////////////////////////////////////////////////////////////////////////////////
//Select count(*) Into :iCnt From mchrsl_image
// Where sabu = :gs_sabu And mchgb = '1' And mchno = :sMchNo   ;
//
//If iCnt = 0 Then Return -1
//
//SELECTBLOB image into :lblobBMP from lw_mchmes_image
// Where sabu = :gs_sabu And mchgb = '1' And mchno = :sMchNo ;
// 
//If sqlca.sqlcode = -1 Then
//	MessageBox("SQL error",SQLCA.SQLErrText,Information!)
//	Return -1
//End If
//
//// Instance 변수에 보관
//iblobBMP = lblobBMP
//
//If p_img.SetPicture(iblobBMP) = 1 Then
//	p_img.Visible = True
//End if
//
Return 1
end function

event open;call super::open;
//gs_gubun		= trim(dw_insert.getitemstring(1,'mchrsl_sidat'))
//gs_code			= dw_insert.getitemstring(1,'mchrsl_gubun')
//gs_codename	= trim(dw_insert.getitemstring(1,'mchrsl_mchno'))
//gi_page			= dw_insert.getitemnumber(1,'mchrsl_seq')
//

is_sidat		= gs_gubun
is_gubun		= gs_code
is_mchno	= gs_codename
ii_seq			= gi_page

int iCnt

SELECT count(*)
    INTO :iCnt
   FROM MCHRSL_IMAGE
 WHERE SABU		= :gs_sabu
	 AND SIDAT		= :is_sidat
	 AND GUBUN		= :is_gubun
	 AND MCHNO	= :is_mchno
	 AND SEQ		= :ii_seq;

If iCnt > 0 Then
	
	SELECTBLOB IMAGE
			  INTO :iblob_IMG1
			FROM MCHRSL_IMAGE
		 WHERE SABU		= :gs_sabu
			 AND SIDAT		= :is_sidat
			 AND GUBUN		= :is_gubun
			 AND MCHNO	= :is_mchno
			 AND SEQ		= :ii_seq;
	 
	If sqlca.sqlcode = -1 Then
		MessageBox("SQL error",SQLCA.SQLErrText,Information!)
		Return
	End If

	If p_img1.SetPicture(iblob_IMG1) = 1 Then
		p_img1.Visible = True
	End if

	SELECTBLOB IMAGE2
			  INTO :iblob_IMG2
			FROM MCHRSL_IMAGE
		 WHERE SABU		= :gs_sabu
			 AND SIDAT		= :is_sidat
			 AND GUBUN		= :is_gubun
			 AND MCHNO	= :is_mchno
			 AND SEQ		= :ii_seq;
	 
	If sqlca.sqlcode = -1 Then
		MessageBox("SQL error",SQLCA.SQLErrText,Information!)
		Return
	End If

	If p_img2.SetPicture(iblob_IMG2) = 1 Then
		p_img2.Visible = True
	End if
	
End if

end event

on w_pdt_06044_image.create
int iCurrent
call super::create
this.p_1=create p_1
this.p_2=create p_2
this.p_3=create p_3
this.p_4=create p_4
this.p_img1=create p_img1
this.p_img2=create p_img2
this.st_2=create st_2
this.st_3=create st_3
this.p_img_del1=create p_img_del1
this.p_img_add1=create p_img_add1
this.p_img_add2=create p_img_add2
this.p_img_del2=create p_img_del2
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.p_1
this.Control[iCurrent+2]=this.p_2
this.Control[iCurrent+3]=this.p_3
this.Control[iCurrent+4]=this.p_4
this.Control[iCurrent+5]=this.p_img1
this.Control[iCurrent+6]=this.p_img2
this.Control[iCurrent+7]=this.st_2
this.Control[iCurrent+8]=this.st_3
this.Control[iCurrent+9]=this.p_img_del1
this.Control[iCurrent+10]=this.p_img_add1
this.Control[iCurrent+11]=this.p_img_add2
this.Control[iCurrent+12]=this.p_img_del2
this.Control[iCurrent+13]=this.rr_1
this.Control[iCurrent+14]=this.rr_2
end on

on w_pdt_06044_image.destroy
call super::destroy
destroy(this.p_1)
destroy(this.p_2)
destroy(this.p_3)
destroy(this.p_4)
destroy(this.p_img1)
destroy(this.p_img2)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.p_img_del1)
destroy(this.p_img_add1)
destroy(this.p_img_add2)
destroy(this.p_img_del2)
destroy(this.rr_1)
destroy(this.rr_2)
end on

type dw_jogun from w_inherite_popup`dw_jogun within w_pdt_06044_image
boolean visible = false
integer x = 3643
integer y = 228
integer width = 91
integer height = 88
end type

type p_exit from w_inherite_popup`p_exit within w_pdt_06044_image
boolean visible = false
integer x = 3845
integer y = 48
boolean enabled = false
end type

event p_exit::clicked;call super::clicked;//SetNull(gs_code)
//SetNull(gs_codename)
//SetNull(gs_gubun)
//
//gs_code = String(dw_1.RowCount())
//Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_pdt_06044_image
boolean visible = false
integer x = 3497
integer y = 48
boolean enabled = false
boolean originalsize = false
end type

type p_choose from w_inherite_popup`p_choose within w_pdt_06044_image
boolean visible = false
integer x = 3671
integer y = 48
boolean enabled = false
end type

type dw_1 from w_inherite_popup`dw_1 within w_pdt_06044_image
boolean visible = false
integer x = 3776
integer y = 216
integer width = 114
integer height = 112
end type

type sle_2 from w_inherite_popup`sle_2 within w_pdt_06044_image
boolean visible = false
end type

type cb_1 from w_inherite_popup`cb_1 within w_pdt_06044_image
boolean visible = false
end type

type cb_return from w_inherite_popup`cb_return within w_pdt_06044_image
boolean visible = false
end type

type cb_inq from w_inherite_popup`cb_inq within w_pdt_06044_image
boolean visible = false
end type

type sle_1 from w_inherite_popup`sle_1 within w_pdt_06044_image
boolean visible = false
end type

type st_1 from w_inherite_popup`st_1 within w_pdt_06044_image
boolean visible = false
end type

type p_1 from picture within w_pdt_06044_image
event ue_lbuttonup pbm_lbuttonup
event ue_lbuttondown pbm_lbuttondown
boolean visible = false
integer x = 4023
integer y = 48
integer width = 178
integer height = 144
boolean bringtotop = true
string pointer = "HyperLink!"
string picturename = "C:\erpman\image\추가_up.gif"
boolean focusrectangle = false
end type

event ue_lbuttonup;This.PictureName = 'C:\erpman\image\추가_up.gif'
end event

event ue_lbuttondown;This.PictureName = 'C:\erpman\image\추가_dn.gif'
end event

type p_2 from picture within w_pdt_06044_image
event ue_lbuttondown pbm_lbuttondown
event ue_lbuttonup pbm_lbuttonup
boolean visible = false
integer x = 4023
integer y = 196
integer width = 178
integer height = 144
boolean bringtotop = true
string pointer = "HyperLink!"
string picturename = "C:\erpman\image\삭제_up.gif"
boolean focusrectangle = false
end type

event ue_lbuttondown;This.PictureName = 'C:\erpman\image\삭제_dn.gif'
end event

event ue_lbuttonup;This.PictureName = 'C:\erpman\image\삭제_up.gif'
end event

type p_3 from picture within w_pdt_06044_image
event ue_lbuttondown pbm_lbuttondown
event ue_lbuttonup pbm_lbuttonup
integer x = 2839
integer y = 20
integer width = 178
integer height = 144
boolean bringtotop = true
string pointer = "HyperLink!"
string picturename = "C:\erpman\image\저장_up.gif"
boolean focusrectangle = false
end type

event ue_lbuttondown;This.PictureName = 'C:\erpman\image\저장_dn.gif'
end event

event ue_lbuttonup;This.PictureName = 'C:\erpman\image\저장_up.gif'
end event

event clicked;Long	ll_cnt

if len(iblob_IMG1) = 0 then
	MessageBox('이미지 확인', '수리 전 사진을 먼저 등록하십시오!')
	return
end if
if len(iblob_IMG2) = 0 then
	MessageBox('이미지 확인', '수리 후 사진을 먼저 등록하십시오!')
	return
end if

sqlca.autocommit = TRUE

SELECT count(*)
    INTO :ll_cnt
   FROM MCHRSL_IMAGE
 WHERE SABU		= :gs_sabu
	 AND SIDAT		= :is_sidat
	 AND GUBUN		= :is_gubun
	 AND MCHNO	= :is_mchno
	 AND SEQ		= :ii_seq;

If ll_cnt < 1 Then
	INSERT INTO MCHRSL_IMAGE
	(SABU,		SIDAT,		GUBUN,		MCHNO,		SEQ)
	VALUES
	(:gs_sabu,	:is_sidat,		:is_gubun,	:is_mchno,	:ii_seq);
End If

UPDATEBLOB MCHRSL_IMAGE
	 SET IMAGE		= :iblob_IMG1
 WHERE SABU		= :gs_sabu
	 AND SIDAT		= :is_sidat
	 AND GUBUN		= :is_gubun
	 AND MCHNO	= :is_mchno
	 AND SEQ		= :ii_seq;

If SQLCA.SQLCODE = -1 Then
	ROLLBACK USING SQLCA;
	MessageBox("Save Image SQL error-1",SQLCA.SQLErrText,Information!)
	Return
End If

UPDATEBLOB MCHRSL_IMAGE
	 SET IMAGE2	= :iblob_IMG2
 WHERE SABU		= :gs_sabu
	 AND SIDAT		= :is_sidat
	 AND GUBUN		= :is_gubun
	 AND MCHNO	= :is_mchno
	 AND SEQ		= :ii_seq;

If SQLCA.SQLCODE = -1 Then
	ROLLBACK USING SQLCA;
	MessageBox("Save Image SQL error-2",SQLCA.SQLErrText,Information!)
	Return
End If

COMMIT;

sqlca.autocommit = FALSE

SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)
SetNull(gi_page)

Close(Parent)

end event

type p_4 from picture within w_pdt_06044_image
event ue_lbuttondown pbm_lbuttondown
event ue_lbuttonup pbm_lbuttonup
integer x = 3013
integer y = 20
integer width = 178
integer height = 144
boolean bringtotop = true
string pointer = "HyperLink!"
boolean originalsize = true
string picturename = "C:\erpman\image\닫기_up.gif"
boolean focusrectangle = false
end type

event ue_lbuttondown;This.PictureName = 'C:\erpman\image\닫기_dn.gif'
end event

event ue_lbuttonup;This.PictureName = 'C:\erpman\image\닫기_up.gif'
end event

event clicked;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)
SetNull(gi_page)

Close(Parent)

end event

type p_img1 from picture within w_pdt_06044_image
integer x = 78
integer y = 316
integer width = 1490
integer height = 1448
boolean bringtotop = true
boolean focusrectangle = false
end type

type p_img2 from picture within w_pdt_06044_image
integer x = 1682
integer y = 316
integer width = 1490
integer height = 1448
boolean bringtotop = true
boolean focusrectangle = false
end type

type st_2 from statictext within w_pdt_06044_image
integer x = 544
integer y = 240
integer width = 567
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16711680
long backcolor = 33027312
string text = "<< 수리 전 사진 >>"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_3 from statictext within w_pdt_06044_image
integer x = 2139
integer y = 240
integer width = 567
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 33027312
string text = "<< 수리 후 사진 >>"
alignment alignment = center!
boolean focusrectangle = false
end type

type p_img_del1 from picture within w_pdt_06044_image
integer x = 283
integer y = 32
integer width = 178
integer height = 144
boolean bringtotop = true
string pointer = "HyperLink!"
string picturename = "C:\erpman\image\그림취소.gif"
boolean focusrectangle = false
end type

event clicked;Long	ll_cnt

SELECT count(*)
    INTO :ll_cnt
   FROM MCHRSL_IMAGE
 WHERE SABU		= :gs_sabu
	 AND SIDAT		= :is_sidat
	 AND GUBUN		= :is_gubun
	 AND MCHNO	= :is_mchno
	 AND SEQ		= :ii_seq;

If ll_cnt < 1 Then
	MessageBox('이미지 확인', '등록된 이미지가 없습니다.')
	Return
End If

If MessageBox('이미지 삭제', '해당 이미지를 삭제 하시겠습니까?', Question!, YesNo!, 2) <> 1 Then Return

UPDATEBLOB MCHRSL_IMAGE
	 SET IMAGE		= NULL
 WHERE SABU		= :gs_sabu
	 AND SIDAT		= :is_sidat
	 AND GUBUN		= :is_gubun
	 AND MCHNO	= :is_mchno
	 AND SEQ		= :ii_seq;

If SQLCA.SQLCODE = 0 Then
	COMMIT USING SQLCA;
Else
	ROLLBACK USING SQLCA;
	MessageBox('삭제 실패', '이미지 삭제 중 오류가 발생했습니다.')
End If

end event

type p_img_add1 from picture within w_pdt_06044_image
integer x = 101
integer y = 32
integer width = 178
integer height = 144
boolean bringtotop = true
string pointer = "HyperLink!"
string picturename = "C:\erpman\image\그림등록.gif"
boolean focusrectangle = false
string powertiptext = "Image등록"
end type

event clicked;iblob_IMG1 = f_get_image(p_img1)
end event

type p_img_add2 from picture within w_pdt_06044_image
integer x = 1696
integer y = 32
integer width = 178
integer height = 144
boolean bringtotop = true
string pointer = "HyperLink!"
string picturename = "C:\erpman\image\그림등록.gif"
boolean focusrectangle = false
string powertiptext = "Image등록"
end type

event clicked;iblob_IMG2 = f_get_image(p_img2)
end event

type p_img_del2 from picture within w_pdt_06044_image
integer x = 1879
integer y = 32
integer width = 178
integer height = 144
boolean bringtotop = true
string pointer = "HyperLink!"
string picturename = "C:\erpman\image\그림취소.gif"
boolean focusrectangle = false
end type

event clicked;Long	ll_cnt

SELECT count(*)
    INTO :ll_cnt
   FROM MCHRSL_IMAGE
 WHERE SABU		= :gs_sabu
	 AND SIDAT		= :is_sidat
	 AND GUBUN		= :is_gubun
	 AND MCHNO	= :is_mchno
	 AND SEQ		= :ii_seq;

If ll_cnt < 1 Then
	MessageBox('이미지 확인', '등록된 이미지가 없습니다.')
	Return
End If

If MessageBox('이미지 삭제', '해당 이미지를 삭제 하시겠습니까?', Question!, YesNo!, 2) <> 1 Then Return

UPDATEBLOB MCHRSL_IMAGE
	 SET IMAGE2	= NULL
 WHERE SABU		= :gs_sabu
	 AND SIDAT		= :is_sidat
	 AND GUBUN		= :is_gubun
	 AND MCHNO	= :is_mchno
	 AND SEQ		= :ii_seq;

If SQLCA.SQLCODE = 0 Then
	COMMIT USING SQLCA;
Else
	ROLLBACK USING SQLCA;
	MessageBox('삭제 실패', '이미지 삭제 중 오류가 발생했습니다.')
End If

end event

type rr_1 from roundrectangle within w_pdt_06044_image
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 33027312
integer x = 64
integer y = 196
integer width = 1522
integer height = 1584
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_pdt_06044_image
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 33027312
integer x = 1669
integer y = 196
integer width = 1522
integer height = 1584
integer cornerheight = 40
integer cornerwidth = 55
end type

