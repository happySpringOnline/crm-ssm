package com.happyballoon.crm.settings.service;

import com.happyballoon.crm.settings.domain.DicValue;

import java.util.List;
import java.util.Map;

public interface DicValueService {

    int deleteDicValueByTypeCodes(String[] typeCodes);

    int queryDelCountByTypeCodes(String[] typeCodes);

    List<DicValue> queryAllDicValue();

    int saveDicValue(DicValue dicValue);

    List<DicValue> queryDicValueByConditionForPage(Map map);

    int queryTotalDicValueCount();

    List<DicValue> queryDicValueByTypeCode(String typeCode);
}
