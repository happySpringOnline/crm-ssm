package com.happyballoon.crm.workbench.mapper;

import com.happyballoon.crm.workbench.domain.Clue;

import java.util.List;
import java.util.Map;

public interface ClueMapper {

    int deleteByPrimaryKey(String id);

    int insertCreateClue(Clue clue);

    int insertSelective(Clue row);

    Clue selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(Clue row);

    int updateByPrimaryKey(Clue row);

    List<Clue> selectClueByConditionForPage(Map<String, Object> map);

    int selectClueCountByConditionForPage(Map<String, Object> map);

    Clue selectClueForDetailById(String id);

    Clue selectClueForConvertById(String id);

    int deleteClueByIds(String[] ids);

}