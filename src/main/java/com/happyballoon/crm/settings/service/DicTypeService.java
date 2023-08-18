package com.happyballoon.crm.settings.service;

import com.happyballoon.crm.settings.domain.DicType;
import org.springframework.stereotype.Service;

import java.util.List;


public interface DicTypeService {

    List<DicType> queryAllDicType();

    int saveCreateDicType(DicType dicType);

    DicType queryDicTypeByCode(String code);

    int updateDicTypeByCode(DicType dicType);

    int deleteDicTypeByBatch(String[] codes);

}
