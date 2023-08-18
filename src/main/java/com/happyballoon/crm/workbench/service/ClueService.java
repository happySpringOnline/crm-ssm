package com.happyballoon.crm.workbench.service;

import com.happyballoon.crm.workbench.domain.Clue;

import java.util.List;
import java.util.Map;

public interface ClueService {

    int saveCreateClue(Clue clue);

    List<Clue> queryClueByConditionForPage(Map<String, Object> map);

    int queryClueCountByConditionForPage(Map<String, Object> map);

    Clue queryClueForDetailById(String id);

    Clue queryClueForEditById(String id);

    int saveEditedClue(Clue clue);

    void saveConvertClue(Map<String,Object> map);

    void deleteClueByIds(String[] ids);
}
