package com.happyballoon.crm.workbench.service.impl;

import com.happyballoon.crm.workbench.domain.Clue;
import com.happyballoon.crm.workbench.domain.ClueRemark;
import com.happyballoon.crm.workbench.mapper.ClueMapper;
import com.happyballoon.crm.workbench.mapper.ClueRemarkMapper;
import com.happyballoon.crm.workbench.service.ClueRemarkService;
import com.happyballoon.crm.workbench.service.ClueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service("clueRemarkService")
public class ClueRemarkServiceImpl implements ClueRemarkService {

    @Autowired
    private ClueRemarkMapper clueRemarkMapper;

    public List<ClueRemark> queryClueRemarkForDetailByClueId(String clueId) {
        return clueRemarkMapper.selectClueRemarkForDetailByClueId(clueId);
    }

    public int saveClueRemark(ClueRemark remark) {
        return clueRemarkMapper.insert(remark);
    }

    public int saveEditClueRemark(ClueRemark remark) {
        return clueRemarkMapper.updateByPrimaryKeySelective(remark);
    }

    public int deleteClueRemarkById(String id) {
        return clueRemarkMapper.deleteByPrimaryKey(id);
    }
}
