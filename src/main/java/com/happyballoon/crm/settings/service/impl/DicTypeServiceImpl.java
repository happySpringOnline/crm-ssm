package com.happyballoon.crm.settings.service.impl;

import com.happyballoon.crm.settings.domain.DicType;
import com.happyballoon.crm.settings.mapper.DicTypeMapper;
import com.happyballoon.crm.settings.service.DicTypeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service("dicTypeService")
public class DicTypeServiceImpl implements DicTypeService {

    @Autowired
    private DicTypeMapper dicTypeMapper;

    public List<DicType> queryAllDicType() {
        return dicTypeMapper.selectAllDicType();
    }

    public int saveCreateDicType(DicType dicType) {
        return dicTypeMapper.insertDicType(dicType);
    }

    public DicType queryDicTypeByCode(String code) {
        return dicTypeMapper.selectDicTypeByCode(code);
    }

    public int updateDicTypeByCode(DicType dicType) {
        return dicTypeMapper.updateDicTypeByCode(dicType);
    }

    public int deleteDicTypeByBatch(String[] codes) {
        return dicTypeMapper.deleteDicTypeByBatch(codes);
    }



}
