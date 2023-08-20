package com.happyballoon.crm.workbench.service;

import com.happyballoon.crm.workbench.domain.FunnelVO;
import com.happyballoon.crm.workbench.domain.Tran;
import com.happyballoon.crm.workbench.domain.TranHistory;

import java.util.List;
import java.util.Map;

public interface TranService {

    void saveCreateTran(Map<String,Object> map);

    int queryTotalCountForPageByCondition(Map<String,Object> map);

    List<Tran> queryTranListForPageByCondition(Map<String,Object> map);

    Tran queryTranEditForEditById(String id);

    void saveEditedTran(Map<String,Object> map);

    Tran queryTranForDetailById(String id);

    List<FunnelVO> queryCountOfTranGroupByStage();

    List<Tran> queryTranListByContactsId(String contactsId);

    void deleteContactsByIds(String[] id);

    List<Tran> queryTranListByCustomerId(String customerId);

    void updateStage(Tran tran, TranHistory tranHitsory);
}
