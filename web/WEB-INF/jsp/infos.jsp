<%@ page import="bean.BeanInfo" %>
<%@ page import="java.util.List" %><%--
  Created by IntelliJ IDEA.
  User: lenovo
  Date: 2019/6/1
  Time: 17:05
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="UTF-8">
    <title>地址</title>
    <script src="https://cdn.jsdelivr.net/npm/vue/dist/vue.js"></script>
    <script src="https://cdn.staticfile.org/axios/0.18.0/axios.min.js"></script>
    <link rel="stylesheet" href="css/left.css" media="screen" type="text/css" />
    <%--need    info.css--%>
    <link rel="stylesheet" href="css/table.css" media="screen" type="text/css" />
</head>


<body>
<!-- 侧边栏 -->
<%@include file="left.jsp" %>

<%--主要部分--%>

<div id="infos_root" style="margin-left: 250px;">
    <br>
    <p style="font-family: '华文隶书'; font-size:50px;">
        我的地址
    </p>
    <button @click="addi()"><span>新增</span></button>
    <br>
    <br>
    <table class="htable">
        <tr>
            <th width="120px">姓名</th>
            <th width="400px">地址</th>
            <th width="300px">电话</th>
            <th width="200px">操作</th>
        </tr>
    </table>
    <div v-for="(item,index) of infos" class="mtable">
        <table>
            <tr>
                <th width="120px">{{item.name}}</th>
                <th width="400px">{{item.address}}</th>
                <th width="300px">{{item.tel}}</th>
                <th width="200px">
                    <button @click="modifyi(item.id)"><span>修改</span></button>
                    <button @click="deli(item.id)"><span>删除</span></button>
                </th>
            </tr>
        </table>
    </div>
</div>
<script>
    new Vue({
        el:"#infos_root",
        data:{
            infos:[]
        },
        mounted:function () {
            <%
            List<BeanInfo> bis=(List<BeanInfo>) session.getAttribute("infosList");
            for(BeanInfo bi:bis){
		    %>
            var bi = new Object();
            bi.id=<%=bi.getInfo_id() %>;
            bi.address="<%=bi.getAddress() %>";
            bi.tel="<%=bi.getTel() %>";
            bi.name="<%=bi.getI_name() %>";
            this.infos.push(bi);
            <%
                }
            %>
        },
        methods:{
            addi:function(){
                location.href = "showaddinfos";

            },
            modifyi:function(iid){
                var params = new Object();
                params.Modify = iid;
                axios.get('chosemodifyinfo' , {params:params})
                    .then(function (res) {
                        console.log(res);
                        if(res.data=="1"){
                            location.href = "showmodifyinfos";
                        }
                        else{
                            alert(res.data);
                        }
                    })
                    .catch(function (error) { // 请求失败处理
                        alert(error);
                    })

            },
            deli:function(iid){
                var params = new Object();
                params.Remove = iid;
                axios.get('removeinfos' , {params:params})
                    .then(function (res) {
                        console.log(res);
                        if(res.data=="1"){
                            location.href = "showinfos";
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
