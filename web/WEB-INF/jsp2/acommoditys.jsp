<%@ page import="bean.BeanCommodity" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Collection" %>
<%@ page import="cart.ShoppingCart" %>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="UTF-8">
    <title>商品目录</title>
    <script src="https://cdn.jsdelivr.net/npm/vue/dist/vue.js"></script>
    <script src="https://cdn.staticfile.org/axios/0.18.0/axios.min.js"></script>
    <link rel="stylesheet" href="css/left.css" media="screen" type="text/css" />
    <link rel="stylesheet" href="css/table.css" media="screen" type="text/css" />
</head>
<body>
<!-- 侧边栏 -->
<%@include file="aleft.jsp" %>

<!-- 主要部分 -->
<div id="ac_root">
    <div style="margin-left: 250px;">
        <br>
        <br>
        <button @click="addc()"><span>新增</span></button>
        <br>
        <br>
        <table class="htable">
            <tr>
                <th width="153px">商品id</th>
                <th width="153px">商品名称</th>
                <th width="153px">商品价格</th>
                <th width="153px">商品库存</th>
                <th width="283px">操作</th>
            </tr>
        </table>
        <div v-for="(item,index) of commoditys" class="mtable" >
            <table>
            <tr>
                <th width="150px">{{item.id}}</th>
                <th width="150px">{{item.name}}</th>
                <th width="150px">{{item.price}}</th>
                <th width="150px">{{item.inventory}}</th>
                <th width="280px">
                    <button @click="modifyc(item.id)"><span>修改</span></button>
                    <button @click="removec(item.id)"><span>删除</span></button>
                    <button @click="orderdetail(item.id)"><span>详情</span></button>
                </th>
            </tr>
            </table>
        </div>
    </div>
</div>
<script>
    new Vue({
        el:"#ac_root",
        data:{
            commoditys:[]
        },
        mounted:function () {
            <%
            List<BeanCommodity> bcs= (List<BeanCommodity>) session.getAttribute("commoditys");
            for(BeanCommodity bc:bcs){
		    %>
            var bc = new Object();
            bc.id=<%=bc.getC_id() %>;
            bc.price=<%=bc.getC_price() %>;
            bc.name="<%=bc.getC_name() %>";
            bc.inventory=<%=bc.getC_inventory() %>;
            this.commoditys.push(bc);
            <%
                }
            %>
        },
        methods:{
            addc:function(){
                location.href = "showaddcommoditys";
            },
            modifyc:function(cid){
                var params = new Object();
                params.c_id=cid;
                axios.get('getcid' , {params:params})
                    .then(function (res) {
                        console.log(res);
                        if(res.data=="1"){
                            location.href = "showupdatecommoditys";
                        }
                        else{
                            alert(res.data);
                        }
                    })
                    .catch(function (error) { // 请求失败处理
                        alert(error);
                    })

            },
            removec: function(cid){
                var params = new Object();
                params.c_id=cid;
                axios.get('removecommoditys' , {params:params})
                    .then(function (res) {
                        console.log(res);
                        if(res.data=="1"){
                            alert("删除成功");
                            location.href = "acommoditys";
                        }
                        else{
                            alert(res.data);
                        }
                    })
                    .catch(function (error) { // 请求失败处理
                        alert(error);
                    })
            },
            show_c :function(cid){
                var params = new Object();
                params.c_id=cid;
                axios.get('commoditydetails' , {params:params})
                    .then(function (res) {
                        console.log(res);
                        if(res.data=="1"){
                            location.href = "showcdetails";
                        }
                        else{
                            alert(res.data);
                        }
                    })
                    .catch(function (error) { // 请求失败处理
                        alert(error);
                    })
            },

        },



    })
</script>
</body>
</html>
