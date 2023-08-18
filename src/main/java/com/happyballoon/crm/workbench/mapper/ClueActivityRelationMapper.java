package com.happyballoon.crm.workbench.mapper;

import com.happyballoon.crm.workbench.domain.ClueActivityRelation;

import java.util.List;

public interface ClueActivityRelationMapper {

    int deleteByPrimaryKey(String id);

    int insert(ClueActivityRelation row);

    int insertSelective(ClueActivityRelation row);

    ClueActivityRelation selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(ClueActivityRelation row);

    int updateByPrimaryKey(ClueActivityRelation row);

    int insertClueActivityRelationByList(List<ClueActivityRelation> list);

    int deleteClueActivityRelationByClueIdActivityId(ClueActivityRelation relation);

    List<ClueActivityRelation> selectRelationByClueId(String clueId);

    int deleteRelationByClueId(String clueId);

    int deleteRelationByAids(String[] activityIds);

    int deleteRelationByclueIds(String[] clueIds);
}
