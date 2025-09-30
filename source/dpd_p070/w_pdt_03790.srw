$PBExportHeader$w_pdt_03790.srw
$PBExportComments$생산실적(구분별)
forward
global type w_pdt_03790 from w_standard_print
end type
end forward

global type w_pdt_03790 from w_standard_print
string title = "생산 실적(구분별)"
end type
global w_pdt_03790 w_pdt_03790

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string ls_syy, ls_gubun, ls_mm, ls_bungi, ls_bangi, ls_ittyp, ls_gubun1, &
       ls_arg_m1, ls_arg_m2, ls_text
long   ll_chasu

if dw_ip.accepttext() <> 1 then return -1

ls_gubun = dw_ip.getitemstring(1,'gubun')
ls_syy   = Trim(dw_ip.getitemstring(1,'syy'))
ls_mm    = dw_ip.getitemstring(1,'mm')
ls_bungi = dw_ip.getitemstring(1,'bungi')
ls_bangi = dw_ip.getitemstring(1,'bangi')
ls_ittyp = dw_ip.getitemstring(1,'sittyp')
ls_gubun1 = dw_ip.getitemstring(1,'gubun1')

if ls_syy = "" or isnull(ls_syy) then
	f_message_chk(30,'[계획년도]')
	dw_ip.setcolumn('syy')
	dw_ip.setfocus()
	return -1
end if

SELECT MAX(YEACHA)  
  INTO :ll_chasu
  FROM YEAPLN  
 WHERE SABU    = :gs_sabu
   AND YEAYYMM like :ls_syy||'%' ;

if isnull(ll_chasu) or ll_chasu < 1 then ll_chasu = 1

if ls_ittyp = "" or isnull(ls_ittyp) then ls_ittyp = '%'

if ls_gubun = '1' then
   if ls_mm = "" or isnull(ls_mm)then
	   f_message_chk(30,'[월]')
		dw_ip.setcolumn('mm')
		dw_ip.setfocus()
		return -1
	end if	
   ls_arg_m1 = ls_mm
	ls_arg_m2 = ls_mm
	ls_text = ls_mm + '월'
elseif ls_gubun = '2' then
	if ls_bungi = "" or isnull(ls_bungi)then
		f_message_chk(30,'[분기]')
		dw_ip.setcolumn('bungi')
		dw_ip.setfocus()
		return -1
	end if

   CHOOSE CASE ls_bungi 
		CASE '1'
		  ls_arg_m1 = '01' 
		  ls_arg_m2 = '03'
		  ls_text = '1/4 분기'
	   case '2'
			ls_arg_m1 = '04'
			ls_arg_m2 = '06'
		  ls_text = '2/4 분기'
		case '3'
			ls_arg_m1 = '07'
			ls_arg_m2 = '09'
		  ls_text = '3/4 분기'
		case '4'
			ls_arg_m1 = '10'
			ls_arg_m2 = '12'
		  ls_text = '4/4 분기'
	END CHOOSE

elseif ls_gubun = '3' then
	if ls_bangi = "" or isnull(ls_bangi)then
		f_message_chk(30,'[반기]')
		dw_ip.setcolumn('bangi')
		dw_ip.setfocus()
		return -1
	end if

	CHOOSE CASE ls_bangi
		CASE '1'
		  ls_arg_m1 = '01' 
		  ls_arg_m2 = '06'
		  ls_text = '상반기'
		case '2'
			ls_arg_m1 = '07'
			ls_arg_m2 = '12'
		  ls_text = '하반기'
	END CHOOSE

elseif  ls_gubun = '4' then
	 ls_arg_m1 = '01'
	 ls_arg_m2 = '12'
end if

dw_list.object.yymm_t.text= ls_text

if ls_gubun1 = '5' or ls_gubun1 = '4' then
	if dw_list.retrieve(gs_sabu, ls_syy, ll_chasu, ls_arg_m1, ls_arg_m2, ls_ittyp) < 1 then
		f_message_chk(300,'')
		dw_ip.setcolumn('gubun')
		dw_ip.setfocus()
		return -1
	end if
else
	if dw_list.retrieve( gs_sabu, ls_gubun1, ls_syy, ll_chasu, ls_arg_m1, ls_arg_m2, ls_ittyp) < 1 then
		f_message_chk(300,'')
		dw_ip.setcolumn('gubun')
		dw_ip.setfocus()
		return -1
	end if
end if

return 1	
	


end function

on w_pdt_03790.create
call super::create
end on

on w_pdt_03790.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;dw_ip.settransobject(sqlca)
dw_ip.setitem(1,'syy',left(f_today(),4))

dw_ip.object.bangi_t.visible = false
dw_ip.object.bungi_t.visible = false
dw_ip.object.bangi.visible = false
dw_ip.object.bungi.visible = false

//<DW Control Name>.Object.<Columnname>.Visible
end event

type p_preview from w_standard_print`p_preview within w_pdt_03790
end type

type p_exit from w_standard_print`p_exit within w_pdt_03790
end type

type p_print from w_standard_print`p_print within w_pdt_03790
end type

type p_retrieve from w_standard_print`p_retrieve within w_pdt_03790
end type







type dw_ip from w_standard_print`dw_ip within w_pdt_03790
integer x = 50
integer y = 84
integer height = 1240
string dataobject = "d_pdt_03790"
end type

event dw_ip::itemchanged;call super::itemchanged;string   ls_gubun , ls_syy


CHOOSE CASE this.GetColumnName()
	Case 'gubun'
		ls_gubun = this.gettext()
	    
		if ls_gubun = '1' then   // 월
		   dw_ip.object.mm_t.visible = true
			dw_ip.object.mm.visible = true
			dw_ip.object.bangi_t.visible = false
         dw_ip.object.bungi_t.visible = false
         dw_ip.object.bangi.visible = false
         dw_ip.object.bungi.visible = false
		elseif ls_gubun = '2' then  // 분기 
			dw_ip.object.mm_t.visible = false
			dw_ip.object.mm.visible = false
			dw_ip.object.bangi_t.visible = false
         dw_ip.object.bungi_t.visible = true
         dw_ip.object.bangi.visible = false
         dw_ip.object.bungi.visible = true
		elseif ls_gubun = '3' then  // 반기 
			dw_ip.object.mm_t.visible = false
			dw_ip.object.mm.visible = false
			dw_ip.object.bangi_t.visible = true
         dw_ip.object.bungi_t.visible = false
         dw_ip.object.bangi.visible = true
         dw_ip.object.bungi.visible = false
		elseif ls_gubun = '4' then // 년 
			dw_ip.object.mm_t.visible = false
			dw_ip.object.mm.visible = false
			dw_ip.object.bangi_t.visible = false
         dw_ip.object.bungi_t.visible = false
         dw_ip.object.bangi.visible = false
         dw_ip.object.bungi.visible = false
	   end if
		
	Case 'gubun1'
		ls_gubun = this.gettext()
		
		IF ls_gubun =  '1'  then
			dw_list.dataobject = "d_pdt_03790_01"
		elseIF ls_gubun =  '2'  then
			dw_list.dataobject = "d_pdt_03790_01"
		elseIF ls_gubun =  '3'  then
			dw_list.dataobject = "d_pdt_03790_01"
		elseif ls_gubun = '4' then
			dw_list.dataobject = "d_pdt_03790_03"
		elseif ls_gubun = '5' then
			dw_list.dataobject = "d_pdt_03790_02"
      end if
		
      dw_list.SetTransObject(SQLCA)

  END CHOOSE


end event

event dw_ip::itemerror;RETURN 1
end event

event dw_ip::error;call super::error;return
end event

event dw_ip::dberror;call super::dberror;return 1
end event

type dw_list from w_standard_print`dw_list within w_pdt_03790
integer x = 805
integer y = 28
integer width = 2825
string dataobject = "d_pdt_03790_01"
end type

