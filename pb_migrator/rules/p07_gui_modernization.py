# -*- coding: utf-8 -*-
"""
마이그레이션 규칙: P-07 UI/UX 현대화
"""

import re
from . import p05_controls

def get_control_properties(control_block):
    """컨트롤 정의 블록 문자열에서 x, y, width, height 속성을 추출합니다."""
    props = {"x": 0, "y": 0, "width": 0, "height": 0}
    x_match = re.search(r'x\s*=\s*(\d+)', control_block, re.IGNORECASE)
    y_match = re.search(r'y\s*=\s*(\d+)', control_block, re.IGNORECASE)
    width_match = re.search(r'width\s*=\s*(\d+)', control_block, re.IGNORECASE)
    height_match = re.search(r'height\s*=\s*(\d+)', control_block, re.IGNORECASE)
    
    if x_match: props["x"] = int(x_match.group(1))
    if y_match: props["y"] = int(y_match.group(1))
    if width_match: props["width"] = int(width_match.group(1))
    if height_match: props["height"] = int(height_match.group(1))
    return props

def reposition_control(code, control_name, original_window_props, target_rect_props, original_control_props, padding=40):
    """컨트롤의 속성을 수정하여 새로운 위치로 재배치하는 헬퍼 함수입니다."""
    pattern = re.compile(f'(type\s+{control_name}\s+from[\s\S]*?)(end type)', re.IGNORECASE)
    match = pattern.search(code)
    
    if not match:
        return code, False

    control_block_full = match.group(0)
    control_block_start = match.group(1)
    control_block_end = match.group(2)

    # --- 새로운 위치 및 크기 계산 ---
    # DataWindow 컨트롤들은 특별 취급하여 target_rect를 꽉 채우도록 크기를 조정합니다.
    if control_name.lower().startswith(('dw_list', 'dw_detail', 'dw_ip', 'dw_cond')):
        new_x = target_rect_props["x"] + padding
        new_y = target_rect_props["y"] + padding
        new_width = target_rect_props["width"] - (2 * padding)
        new_height = target_rect_props["height"] - (2 * padding)
    else:
        # 다른 컨트롤들은 기존 크기를 유지한 채 위치만 재조정합니다.
        # 원본 윈도우 내에서의 상대적 위치 비율을 계산합니다.
        # (주의: 이 방식은 컨트롤이 그룹박스 등에 속해있을 경우 정확하지 않을 수 있습니다.)
        rel_x_ratio = original_control_props["x"] / original_window_props["width"] if original_window_props["width"] > 0 else 0
        rel_y_ratio = original_control_props["y"] / original_window_props["height"] if original_window_props["height"] > 0 else 0

        # 새로운 사각형 내에서의 절대 위치를 계산합니다.
        new_x = target_rect_props["x"] + int(rel_x_ratio * target_rect_props["width"])
        new_y = target_rect_props["y"] + int(rel_y_ratio * target_rect_props["height"])
        new_width = original_control_props["width"]
        new_height = original_control_props["height"]

    # 컨트롤이 너무 작아지거나 영역을 벗어나는 것을 방지합니다.
    new_width = max(10, new_width)
    new_height = max(10, new_height)

    # 기존 위치/크기 속성을 제거합니다.
    control_block_start = re.sub(r'integer\s+x\s*=\s*\d+\r?\n', '', control_block_start, flags=re.IGNORECASE)
    control_block_start = re.sub(r'integer\s+y\s*=\s*\d+\r?\n', '', control_block_start, flags=re.IGNORECASE)
    control_block_start = re.sub(r'integer\s+width\s*=\s*\d+\r?\n', '', control_block_start, flags=re.IGNORECASE)
    control_block_start = re.sub(r'integer\s+height\s*=\s*\d+\r?\n', '', control_block_start, flags=re.IGNORECASE)

    # 새로운 위치/크기 속성을 추가합니다.
    new_properties_str = f'''\r\ninteger x = {new_x}\r\ninteger y = {new_y}\r\ninteger width = {new_width}\r\ninteger height = {new_height}'''
    
    new_control_block = control_block_start.rstrip() + new_properties_str + '\r\n' + control_block_end
    
    return code.replace(control_block_full, new_control_block), True

def apply(code, **kwargs):
    """
    P-07 규칙: 윈도우의 레이아웃을 재구성하고 주요 컨트롤들을 재배치합니다.
    """
    
    window_name_match = re.search(r'global type (w_\w+)\s+from', code)
    if not window_name_match:
        return code, {"rule": "P-07", "status": "오류", "details": "윈도우 이름을 찾을 수 없습니다."}
    window_name = window_name_match.group(1)

    # 실제 구현 블록(속성을 포함)을 대상으로 하는 더 구체적인 패턴
    window_block_pattern = re.compile(fr'(global\s+type\s+{window_name}\s+from\s+\w+[\s\S]*?(?:integer|string|boolean)[\s\S]*?)(end\s+type)', re.IGNORECASE)
    window_block_match = window_block_pattern.search(code)
    
    if not window_block_match:
        return code, {"rule": "P-07", "status": "오류", "details": f"{window_name} 윈도우의 메인 정의 블록을 찾을 수 없습니다."}
    
    window_block = window_block_match.group(0)

    width_match = re.search(r'integer width = (\d+)', window_block)
    height_match = re.search(r'integer height = (\d+)', window_block)

    original_width = int(width_match.group(1)) if width_match else 4600
    original_height = int(height_match.group(1)) if height_match else 2300

    original_window_props = {"width": original_width, "height": original_height}

    code, p05_report = p05_controls.apply(code)
    
    r_head_props = {"x": 32, "y": 32, "width": 4562, "height": 308}
    r_detail_props = {"x": 32, "y": 352, "width": 4562, "height": 1964}

    r_head_def = f'''type r_head from rectangle within {window_name}\nlong linecolor = 28543105\ninteger linethickness = 4\nlong fillcolor = 12639424\ninteger x = {r_head_props[
