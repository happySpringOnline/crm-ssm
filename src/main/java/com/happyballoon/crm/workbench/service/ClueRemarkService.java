package com.happyballoon.crm.workbench.service;

import com.happyballoon.crm.workbench.domain.ClueRemark;

import java.util.List;

public interface ClueRemarkService {

    List<ClueRemark> queryClueRemarkForDetailByClueId(String clueId);

    int saveClueRemark(ClueRemark remark);

    int saveEditClueRemark(ClueRemark remark);

    int deleteClueRemarkById(String id);

}
