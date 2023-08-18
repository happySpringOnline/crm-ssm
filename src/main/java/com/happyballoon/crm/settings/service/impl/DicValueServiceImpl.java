package com.happyballoon.crm.settings.service.impl;

import com.happyballoon.crm.settings.domain.DicValue;
import com.happyballoon.crm.settings.mapper.DicValueMapper;
import com.happyballoon.crm.settings.service.DicValueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service("dicValueService")
public class DicValueServiceImpl implements DicValueService {

    @Autowired
    private DicValueMapper dicValueMapper;

    public int deleteDicValueByTypeCodes(String[] typeCodes) {
        return dicValueMapper.deleteDicValueByTypeCodes(typeCodes);
    }

    public int queryDelCountByTypeCodes(String[] typeCodes) {
        return dicValueMapper.selectDelCountByTypeCodes(typeCodes);
    }

    public List<DicValue> queryAllDicValue() {
        return dicValueMapper.selectAllDicValue();
    }

    public int saveDicValue(DicValue dicValue) {
        return dicValueMapper.insertDicValue(dicValue);
    }

    public List<DicValue> queryDicValueByConditionForPage(Map map) {
        return dicValueMapper.selectAllDicValueForPage(map);
    }

    public int queryTotalDicValueCount() {
        return dicValueMapper.selectTotalCountForPage();
    }

    public List<DicValue> queryDicValueByTypeCode(String typeCode) {
        return dicValueMapper.selectDicValueByTypeCode(typeCode);
    }
}
