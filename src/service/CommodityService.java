package service;

import bean.BeanCommodity;
import cart.ShoppingCart;
import cart.ShoppingCartItem;
import dao.CommodityDao;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.*;

@Service("commodityService")
public class CommodityService {
    @Resource(name = "commodityDao")
    private CommodityDao commodityDao;

    private List<BeanCommodity> commoditys;

    public CommodityDao getCommodityDao() {
        return commodityDao;
    }

    public void setCommodityDao(CommodityDao commodityDao) {
        this.commodityDao = commodityDao;
    }

    //  获取所有商品的集合
    public List<BeanCommodity> getCommoditys() throws Exception {
        List<BeanCommodity> commodities = commodityDao.findAllCommodity();
        Collections.sort(commodities);
        return commoditys;
    }
    //  获取一件商品
    public BeanCommodity getCommodity(int c_id) throws Exception {
        return commodityDao.findCommodityById(c_id);
    }
    //   购买购物车内所有商品
    @Transactional
    public void buyCommoditys(String user_id, ShoppingCart cart, OrderService orderService,int info_id) throws Exception {
        Collection items = cart.getItems();
        Iterator i = items.iterator();

//        生成订单
        int order_id = orderService.generateOrder(user_id,info_id);
        while (i.hasNext()) {
            ShoppingCartItem sci = (ShoppingCartItem) i.next();
            BeanCommodity bc = (BeanCommodity) sci.getItem();
            int c_id = bc.getC_id();
            int od_number = sci.getQuantity();
            float od_price = bc.getC_price();
            buyCommodity(c_id, od_number);
//            生成订单细节
            orderService.generateOrderDetail(order_id,c_id,od_number,od_price);
        }
    }
    //  更新商品存货（购买商品时）
    private void buyCommodity(int c_id, int od_number) throws Exception {
        BeanCommodity commodity = commodityDao.findCommodityById(c_id);
        if (commodity != null){
            int inventory = commodity.getC_inventory();
            if ((inventory - od_number) >= 0){
                commodity.setC_inventory(inventory - od_number);
                commodityDao.updateCommodity(commodity);
            }else
                throw new Exception("Not enough of " + c_id);
        }

    }
}
