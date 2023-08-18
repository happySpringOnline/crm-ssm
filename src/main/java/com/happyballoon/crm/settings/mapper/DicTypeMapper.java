package com.happyballoon.crm.settings.mapper;

import com.happyballoon.crm.settings.domain.DicType;

import java.util.List;

public interface DicTypeMapper {

    int deleteByPrimaryKey(String code);

    int insertDicType(DicType row);

    int insertSelective(DicType row);

    DicType selectDicTypeByCode(String code);

    int updateDicTypeByCode(DicType row);

    int updateByPrimaryKey(DicType row);

    List<DicType> selectAllDicType();

    int deleteDicTypeByBatch(String[] codes);

}