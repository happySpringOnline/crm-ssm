package com.happyballoon.crm.workbench.service;

import com.happyballoon.crm.workbench.domain.TranRemark;

import java.util.List;

public interface TranRemarkService {

    List<TranRemark> queryTranRemarkForDetailByTranId(String tranId);

    int saveTranRemark(TranRemark remark);

    int saveEditTranRemark(TranRemark remark);

    int deleteTranRemarkById(String id);
}
