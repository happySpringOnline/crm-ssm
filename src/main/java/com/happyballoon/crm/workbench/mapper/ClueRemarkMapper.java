package com.happyballoon.crm.workbench.mapper;

import com.happyballoon.crm.workbench.domain.ClueRemark;

import java.util.List;

public interface ClueRemarkMapper {

    int deleteByPrimaryKey(String id);

    int insert(ClueRemark row);

    int insertSelective(ClueRemark row);

    ClueRemark selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(ClueRemark row);

    int updateByPrimaryKey(ClueRemark row);

    List<ClueRemark> selectClueRemarkForDetailByClueId(String clueId);

    List<ClueRemark> selectClueRemarkByClueId(String clueId);

    int deleteClueRemarkByclueId(String clueId);

    int deleteClueRemarkByClueIds(String[] clueIds);
}