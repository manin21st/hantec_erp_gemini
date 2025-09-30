$PBExportHeader$w_qct_01620.srw
$PBExportComments$거래처별 월별 품질현황
forward
global type w_qct_01620 from w_standard_dw_graph
end type
end forward

global type w_qct_01620 from w_standard_dw_graph
string title = "거래처별 월별 품질현황"
end type
global w_qct_01620 w_qct_01620

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string ls_sabu, ls_sdate, ls_stpurpose, ls_m11, senddate
string ls_vndcode1, ls_vndcode2, ls_vndcode3, ls_vndcode4

if dw_ip.AcceptText() = -1 then return -1

ls_sabu = gs_sabu

ls_sdate = dw_ip.GetItemString(1, 'stddate')         //기준년월
ls_vndcode1 = dw_ip.GetItemString(1, 't_vndcode1')     //거래처 코드
ls_vndcode2 = dw_ip.GetItemString(1, 't_vndcode2')     //거래처 코드
ls_vndcode3 = dw_ip.GetItemString(1, 't_vndcode3')     //거래처 코드
ls_vndcode4 = dw_ip.GetItemString(1, 't_vndcode4')     //거래처 코드
ls_stpurpose = dw_ip.GetItemString(1, 'st_purpose')  //목표치 등록

if IsNull(ls_sdate) or ls_sdate = "" then 
	f_message_chk(1400,'[필수입력항목]')
   dw_ip.Setfocus()
   dw_ip.Setcolumn('stddate')
	return -1
end if

if IsNull(ls_vndcode1) or ls_vndcode1 = "" then ls_vndcode1 = '.'
if IsNull(ls_vndcode2) or ls_vndcode2 = "" then ls_vndcode2 = '.'
if IsNull(ls_vndcode3) or ls_vndcode3 = "" then ls_vndcode3 = '.'
if IsNull(ls_vndcode4) or ls_vndcode4 = "" then ls_vndcode4 = '.'

if ls_vndcode1 = '.'  and ls_vndcode2 = '.'  and ls_vndcode3 = '.'  and &
	ls_vndcode4 = '.'  then
	f_message_chk(1400,'[필수입력항목]')
   dw_ip.Setfocus()
   dw_ip.Setcolumn('t_vndcode1')	
	return -1	
end if

if IsNull(ls_stpurpose) or ls_stpurpose = "" then 
	f_message_chk(1400,'[필수입력항목]')
   dw_ip.Setfocus()
   dw_ip.Setcolumn('st_purpose')	
	return -1
end if 


// M-11월을 계산하는 공식
// ls_m11 = M-11개월
if right(ls_sdate, 2) <= "11" then
	ls_m11 = string( long(ls_sdate) - 99)
elseif right(ls_sdate, 2) = "12" then
	ls_m11 = string( long(ls_sdate) - 11)	
else 
	MessageBox("확인", "잘못된 날짜입니다.!!")
end if

dw_list.object.stddate_t.text = left(ls_sdate, 4) + '년' + right(ls_sdate, 2) + '월' 
dw_list.object.purp_t.text = left(ls_sdate, 4) + '년도 목표치 : ' + &
                             string(ls_stpurpose, '@@.@@') +'%'

senddate = ls_sdate+'99'

dw_list.setredraw(false)
if dw_list.retrieve(ls_sabu, ls_vndcode1, ls_vndcode2, ls_vndcode3, ls_vndcode4, ls_m11, senddate) <= 0 then
	dw_list.insertrow(0)
   dw_list.setredraw(true)	
	return -1 
end if
   dw_list.setredraw(true)	
	
return 1

end function

on w_qct_01620.create
call super::create
end on

on w_qct_01620.destroy
call super::destroy
end on

event open;call super::open;dw_list.insertrow(0)
dw_ip.setitem(1, "stddate", left(f_today(), 6))
end event

type p_exit from w_standard_dw_graph`p_exit within w_qct_01620
end type

type p_print from w_standard_dw_graph`p_print within w_qct_01620
end type

type p_retrieve from w_standard_dw_graph`p_retrieve within w_qct_01620
end type

type st_window from w_standard_dw_graph`st_window within w_qct_01620
end type

type st_popup from w_standard_dw_graph`st_popup within w_qct_01620
end type

type pb_title from w_standard_dw_graph`pb_title within w_qct_01620
end type

type pb_space from w_standard_dw_graph`pb_space within w_qct_01620
end type

type pb_color from w_standard_dw_graph`pb_color within w_qct_01620
end type

type pb_graph from w_standard_dw_graph`pb_graph within w_qct_01620
end type

type dw_ip from w_standard_dw_graph`dw_ip within w_qct_01620
integer x = 18
integer y = 12
integer width = 3762
integer height = 212
string dataobject = "d_qct_01620_01"
end type

event dw_ip::itemchanged;string ls_sdate, s_code, fd_code, ls_stpurpose, snull, scvnas

SetNull(snull)

if this.GetColumnName() = "stddate" then 
	ls_sdate = this.GetText()  
   if IsNUll(ls_sdate) or ls_sdate = "" then return  
   if f_datechk(ls_sdate + '01' ) = -1 then //날짜체크 
	   f_message_chk(35,"[사용일자]") 
	   this.SetItem(1, 'stddate', snull)   
	   return 1   
	else   
		return   
   end if  
end if	 

if Left(this.GetColumnName(), 9) = "t_vndcode"  then 
	s_code = this.GetText()
   if IsNUll(s_code) or s_code = "" then
		choose case getcolumnname()
				 case 't_vndcode1'
						this.SetItem(1, "t_vndcode1", snull)
						this.SetItem(1, "vndnm1", snull)
				 case 't_vndcode2'
						this.SetItem(1, "t_vndcode2", snull)
						this.SetItem(1, "vndnm2", snull)
				 case 't_vndcode3'
						this.SetItem(1, "t_vndcode3", snull)
						this.SetItem(1, "vndnm3", snull)
				 case 't_vndcode4'
						this.SetItem(1, "t_vndcode4", snull)
						this.SetItem(1, "vndnm4", snull)
		end choose
	   return 1
	else
	
		  SELECT "VNDMST"."CVNAS"  
			 INTO :scvnas
		  FROM "VNDMST"  
		  WHERE "VNDMST"."SABU" = :gs_sabu  and   
				  "VNDMST"."CVCOD" = :s_code ;		
				  
		  if sqlca.sqlcode = 0 then 
				choose case getcolumnname()
						 case 't_vndcode1'
								this.SetItem(1, "t_vndcode1", fd_code)
								this.SetItem(1, "vndnm1", sCvnas)
						 case 't_vndcode2'
								this.SetItem(1, "t_vndcode2", fd_code)
								this.SetItem(1, "vndnm2", scvnas)
						 case 't_vndcode3'
								this.SetItem(1, "t_vndcode3", fd_code)
								this.SetItem(1, "vndnm3", scvnas)
						 case 't_vndcode4'
								this.SetItem(1, "t_vndcode4", fd_code)
								this.SetItem(1, "vndnm4", scvnas)
				end choose			  
           return 			  
		  else
			  MessageBox("확 인", "해당자료가 존재하지 않습니다.!! ~n 다시 입력하십시오.")			
				choose case getcolumnname()
						 case 't_vndcode1'
								this.SetItem(1, "t_vndcode1", snull)
								this.SetItem(1, "vndnm1", snull)
						 case 't_vndcode2'
								this.SetItem(1, "t_vndcode2", snull)
								this.SetItem(1, "vndnm2", snull)
						 case 't_vndcode3'
								this.SetItem(1, "t_vndcode3", snull)
								this.SetItem(1, "vndnm3", snull)
						 case 't_vndcode4'
								this.SetItem(1, "t_vndcode4", snull)
								this.SetItem(1, "vndnm4", snull)
				end choose  
		     return 1
		  end if
   end if
end if	

if this.GetColumnName() = "st_purpose" then 
	ls_stpurpose = this.GetText()
	if IsNull(ls_stpurpose) or ls_stpurpose = "" then 
		f_message_chk(1400,'[필수입력항목]')
		dw_ip.Setfocus()
		dw_ip.Setcolumn('st_purpose')	
		return -1
	end if 
	return 
end if
end event

event dw_ip::rbuttondown;long lrow
string sname

lrow = this.getrow()
sname = this.GetColumnName()

IF sname = "t_vndcode1" or sname = "t_vndcode2" or &
	sname = "t_vndcode3" or sname = "t_vndcode4" then 
	setnull(gs_code)
	setnull(gs_codename)
	gs_gubun = '1'
	
	open(w_vndmst_popup)
	
	choose case sname
			 case 't_vndcode1'
					this.SetItem(lrow, "t_vndcode1", Gs_code)
					this.SetItem(lrow, "vndnm1", Gs_codename)					
			 case 't_vndcode2'
					this.SetItem(lrow, "t_vndcode2", Gs_code)
					this.SetItem(lrow, "vndnm2", Gs_codename)										
			 case 't_vndcode3'
					this.SetItem(lrow, "t_vndcode3", Gs_code)
					this.SetItem(lrow, "vndnm3", Gs_codename)
			 case 't_vndcode4'
					this.SetItem(lrow, "t_vndcode4", Gs_code)
					this.SetItem(lrow, "vndnm4", Gs_codename)
	end choose		
	
END IF
end event

event dw_ip::itemerror;return 1
end event

type sle_msg from w_standard_dw_graph`sle_msg within w_qct_01620
end type

type dw_datetime from w_standard_dw_graph`dw_datetime within w_qct_01620
end type

type st_10 from w_standard_dw_graph`st_10 within w_qct_01620
end type

type gb_3 from w_standard_dw_graph`gb_3 within w_qct_01620
end type

type dw_list from w_standard_dw_graph`dw_list within w_qct_01620
string title = "거래처별 월별 품질현황"
string dataobject = "d_qct_01620_02"
boolean border = false
end type

type gb_10 from w_standard_dw_graph`gb_10 within w_qct_01620
end type

type rr_1 from w_standard_dw_graph`rr_1 within w_qct_01620
end type

