# [패턴 1 정의]

10.5버전으로 오면서 부모 윈도우가 바뀌었는데, 이 때문에 자식 윈도우에 불필요하게 남은 컨트롤들이 생겼어.
이 컨트롤들은 부모엔 더 이상 없기 때문에 컴파일 에러를 만들거든.

그래서 패턴 1은 이런 '오래된 상속 컨트롤'이랑 관련된 모든 코드들을 찾아서 자동으로 주석 처리해주는 역할을 해.
컴파일 에러를 막는게 주 목적이야.

**어떻게 처리하냐면:**

1.  먼저 자식 윈도우에 있는 컨트롤이 '상속 받은 컨트롤'인지부터 확인해야 해. 이건 컨트롤의 `from` 타입에 부모 윈도우 이름이 들어있는지로 판단할 수 있어.
2.  그렇게 찾은 '상속 컨트롤'이 지금 부모 윈도우에 진짜로 있는지 없는지 비교해봐.
3.  만약 부모 윈도우에 없다면, 그건 '오래된 컨트롤'이니까 주석 처리 대상이 되는거야.
4.  주석 처리할 때는 컨트롤 정의(`type...end type`) 뿐만 아니라, 그 컨트롤을 쓰는 모든 이벤트(`event...end event`), 변수 선언, create/destroy, Control 배열까지 싹 다 찾아서 `//& `를 붙여줘.
5.  마지막으로, 파일 위쪽에 PBMigrator가 수정했다는 주석을 한 줄 추가해줘.

**중요한 점:**

이 패턴은 다른 패턴들이 다 적용되고 나서, 마지막에 불필요한 코드들을 정리하는 개념으로 돌아가야 해.

---

# [패턴 2 정의]

파워빌더10 버전과 10.5 버전 부모윈도우가 변경되었는데
가장 크게 바뀐게 뭐냐면 조회,추가,삭제,저장,닫기 등의 기능을 이미지버튼 방식(10버전)에서
유저이벤트 방식(10.5)으로 변경했다는 거야.
그래서 패턴1에서 주석처리 대상이었던 p_retrieve, p_print, p_xls 등의 이미지 컨트롤에서
처리하던 로직을 ue_retrieve, ue_print, ue_excel 이벤트로 변경해줘야해.

구체적인 예를 들면
event p_inq::clicked;call super::clicked; 는
event ue_retrieve;call super::ue_retrieve; 로 변경하는거야.
그리고 윈도우 이벤트이기 때문에 변경된 블럭(event ue... end event)은
on [윈도우].destroy ... end on 이후에 다른 컨트롤 type ... end type 정의가 나오기 전 사이에 위치해야 하고
앞뒤로 한 줄 간격을 주고 추가하면 돼.

정학한 변환 대상 컨트롤과 이벤트 리스트는 아래와 같아.
p_retrieve -> ue_retrieve
p_inq -> ue_retrieve
p_ins -> ue_append
p_del -> ue_delete
p_mod -> ue_update
p_can -> ue_cancel
p_xls -> ue_excel
p_print -> ue_print
p_preview -> ue_preview
p_search -> ue_seek

결론적으로
패턴1 보다 여기 패턴2가 먼저 처리된 이후에 패턴1이 처리되어야 주석처리를 제대로 할 수 있겠지?
구현 계획을 제안해주고 궁금한게 있으면 물어봐.


---

# [패턴 3 정의]

패턴2 와 패턴1 처리 결과로 변환된 소스를 파워빌더에서 임포트하면 아래 오류가 발생해.
 ---------- Compiler: Errors
mat_e020.pbl(w_mat_03540).w_mat_03540.ue_retrieve.30: Error       C0015: Undefined variable: p_print
mat_e020.pbl(w_mat_03540).w_mat_03540.ue_retrieve.31: Error       C0015: Undefined variable: p_print
mat_e020.pbl(w_mat_03540).w_mat_03540.ue_retrieve.33: Error       C0015: Undefined variable: p_preview
mat_e020.pbl(w_mat_03540).w_mat_03540.ue_retrieve.34: Error       C0015: Undefined variable: p_preview
mat_e020.pbl(w_mat_03540).w_mat_03540.ue_retrieve.35: Error       C0015: Undefined variable: p_xls
mat_e020.pbl(w_mat_03540).w_mat_03540.ue_retrieve.36: Error       C0015: Undefined variable: p_xls
mat_e020.pbl(w_mat_03540).w_mat_03540.ue_retrieve.40: Error       C0015: Undefined variable: p_print
mat_e020.pbl(w_mat_03540).w_mat_03540.ue_retrieve.41: Error       C0015: Undefined variable: p_print
mat_e020.pbl(w_mat_03540).w_mat_03540.ue_retrieve.42: Error       C0015: Undefined variable: p_preview
mat_e020.pbl(w_mat_03540).w_mat_03540.ue_retrieve.43: Error       C0015: Undefined variable: p_preview
mat_e020.pbl(w_mat_03540).w_mat_03540.ue_retrieve.44: Error       C0015: Undefined variable: p_xls
mat_e020.pbl(w_mat_03540).w_mat_03540.ue_retrieve.45: Error       C0015: Undefined variable: p_xls
 ---------- Finished Errors

이유는 패턴1 에서 주석처리된 컨트롤들이 패턴2 에서 여전히 사용되고 있어서 그래.
이걸 해결하는 방법은 패턴2 대상 컨트롤에 대한 Enabled 와 PictureName 변경 방식을 바꿔주는 거야.

구체적인 예를 들면

 (변경 전)
	p_print.Enabled = False
	p_print.PictureName = 'C:\erpman\image\인쇄_d.gif'
 (변경 후)
    w_mdi_frame.uo_toolbarstrip.of_SetEnabled("출력(&P)", false)

변환 대상 컨트롤에 대응되는 of_SetEnabled 함수의 인자(한글)는 아래와 같아.
p_retrieve -> 조회(&Q)
p_inq -> 조회(&Q)
p_ins -> 추가(&A)
p_del -> 삭제(&D)
p_mod -> 저장(&S)
p_xls -> 엑셀변환(&E)
p_print -> 출력(&P)
p_preview -> 미리보기(&R)
p_search -> 찾기(&T)
당연한 얘기지만 of_SetEnabled 함수의 두번째 인자는 Enabled 속성값과 일치해야 해.

위에서 정한 패턴3 규칙 외에는 패턴1 로직을 보완해서 주석 처리해야만 오류가 안나겠지?
구현 계획을 제안해주고 궁금한게 있으면 물어봐.


# [패턴 4 정의]

패턴4 는 dw_cond 라는 데이터윈도우를 dw_input 으로 대체하는 작업이야. 따라서 해당 소스에는 dw_input 이 없어야 해.
패턴2 와 마찬가지로 파워빌더10 버전과 10.5 버전 부모윈도우가 변경되면서 데이터윈도우 dw_input 이 10.5 버전에서 새로 추가되었고, 자료를 조회할 때 조건을 지정하는 용도로 사용했어.

물론 구 버전에서는 상속받지 않은 dw_cond 라는 데이터윈도우가 이 역할을 했었지.
그래서 이번 패턴의 핵심은 dw_cond 를 dw_input 으로 프로그램 오류없이 대체하는 거야.

그럴려면
1. `forward ... end forward` 내부에서 `type dw_cond ... end type` 블럭을 찾아 지울 것
2. `type dw_cond ... end type` 블럭을 찾아 첫 행을 dw_input 에 대한 상속 형식으로 대체할 것
3. `global type ... end type` 내부에서 `dw_cond` 를 찾아 해당 라인을 지울 것
4. `on [윈도우id].create ... end on` 에서 dw_cond 가 포함된 라인을 찾아 지울 것
5. 3번으로 지워진 순번(iCurrent+숫자) 전체를 1번부터 빠지는 번호가 없도록 다시 채번할 것
6. `on [윈도우id].destroy ... end on` 에서 dw_cond 가 포함된 라인을 찾아 지울 것
7. 위 1~5번까지 처리 완료 후 남은 소스 전체에서 dw_cond 를 dw_input 으로 일괄 변경


어제 진행했던 패턴4 말인데, 생각해보니 2가지 방식이 있을 수 있을거
같아. 하나는 지금처럼, 다른 하나는 dw_cond 를 그대로 두면서 dw_input
을 안보이게 하는 방법. 그래서 패턴4 는 둘중 하나를 선택하는
라디오버튼이 추가로 선택 가능해야 할거 같아. 물론 dw_input 이 안보이게
하는 처리는 소스에 dw_input 검색해서 없을 경우에만


구체적인 예시 자료는 아래를 참조해.

forward
global type w_kglc01 from w_inherite
end type
type dw_cond from u_key_enter within w_kglc01		<-- 이 라인 삭제
end type											<-- 이 라인 삭제
type dw_rtv from datawindow within w_kglc01
end type
type dw_2 from u_d_select_sort within w_kglc01
end type
type dw_1 from datawindow within w_kglc01
end type
type rr_1 from roundrectangle within w_kglc01
end type
type rr_2 from roundrectangle within w_kglc01
end type
end forward


global type w_kglc01 from w_inherite
string title = "전표 승인 처리"
dw_cond dw_cond
dw_rtv dw_rtv
dw_2 dw_2
dw_1 dw_1
rr_1 rr_1
rr_2 rr_2
end type
global w_kglc01 w_kglc01


on w_kglc01.create
int iCurrent
call super::create
this.dw_cond=create dw_cond							<-- 이 라인 삭제
this.dw_rtv=create dw_rtv
this.dw_2=create dw_2
this.dw_1=create dw_1
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_cond				<-- 이 라인 삭제
this.Control[iCurrent+2]=this.dw_rtv				<-- iCurrent+1 로 다시 채번
this.Control[iCurrent+3]=this.dw_2					<-- iCurrent+2 로 다시 채번
this.Control[iCurrent+4]=this.dw_1					<-- iCurrent+3 로 다시 채번
this.Control[iCurrent+5]=this.rr_1					<-- iCurrent+4 로 다시 채번
this.Control[iCurrent+6]=this.rr_2					<-- iCurrent+5 로 다시 채번
end on


on w_kglc01.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_cond)								<-- 이 라인 삭제
destroy(this.dw_rtv)
destroy(this.dw_2)
destroy(this.dw_1)
destroy(this.rr_1)
destroy(this.rr_2)
end on


type dw_cond from u_key_enter within w_kglc01		<-- 이 라인을 type dw_input from w_inherite`dw_input within w_kglc01 로 대체
integer x = 55
integer width = 3625
integer height = 316
integer taborder = 10
boolean bringtotop = true
string dataobject = "dw_kglc011"
boolean border = false
end type
