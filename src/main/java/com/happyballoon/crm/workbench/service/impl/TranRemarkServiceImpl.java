package com.happyballoon.crm.workbench.service.impl;

import com.happyballoon.crm.workbench.domain.TranRemark;
import com.happyballoon.crm.workbench.mapper.TranRemarkMapper;
import com.happyballoon.crm.workbench.service.TranRemarkService;
import com.happyballoon.crm.workbench.service.TranService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service("tranRemarkService")
public class TranRemarkServiceImpl implements TranRemarkService {

    @Autowired
    private TranRemarkMapper tranRemarkMapper;

    public List<TranRemark> queryTranRemarkForDetailByTranId(String tranId) {
        return tranRemarkMapper.selectTranRemarkForDetailByTranId(tranId);
    }

    public int saveTranRemark(TranRemark remark) {
        return tranRemarkMapper.insert(remark);
    }

    public int saveEditTranRemark(TranRemark remark) {
        return tranRemarkMapper.updateByPrimaryKeySelective(remark);
    }

    public int deleteTranRemarkById(String id) {
        return tranRemarkMapper.deleteByPrimaryKey(id);
    }
}
