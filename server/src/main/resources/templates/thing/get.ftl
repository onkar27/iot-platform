<#include "../common/header.ftl">
<#include "../blockly/blocklyHeader.ftl"/>
<body>
<#include "../common/navbar.ftl"/>
<#include "../common/chatbot.ftl"/>
<div class="container-fluid" id="container-main">
<#if user??>
    <#include "../common/sidenavbar.ftl"/>
</#if>
    <main role="main" class="main col-sm-9 ml-sm-auto col-md-10 pt-3">
        <div class="row">
            <div class="col-md-12">
                <div class="float-right p-1" v-if="role=='ALL' || role=='WRITE'">
                    <button v-on:click="newDevice" class="btn btn-outline-primary">Add Device</button>
                    <button v-on:click="importThing" class="btn btn-outline-primary">Import Device</button>
                </div>
            </div>
            <div class="clearfix"></div>
        </div>
        <div class="row">
            <div class="col-md-12">
                <div class="card">
                    <div class="card-header">
                        <span>(<span id="thingId">{{ thing.id }}</span>) | </span>
                        <span id="thingName">{{ thing.name }}</span>
                        <div class="float-right">
                            <div class="row clearfix">
                                <img src="/static/img/ajax-loader.gif" v-if="saveLoaderStorage">
                                <div class="col"><label class="badge badge-primary" for="storage">Enable storage</label>
                                </div>
                                <div class="col"><input type="checkbox" id="storage" class="form-check-input"
                                                        v-model="storageEnabled" v-on:change="enableStorage"></div>
                            </div>
                        </div>
                    </div>
                    <div class="card-body p-0">
                        <table class="table mb-0" v-if="devices.length">
                            <thead class="thead-light">
                                <tr>
                                    <th>Device Name</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tr v-for="d in devices">
                                <td>{{d.name}}</td>
                                <td>
                                    <button v-on:click="deleteDevice(d)" class="btn btn-sm btn-danger text-white">
                                        DELETE
                                    </button>
                                    <button v-on:click="editDevice(d)" class="btn btn-sm btn-default">EDIT</button>
                                </td>
                            </tr>
                        </table>
                        <div v-else class="h3 pt-2 pb-2 text-center text-muted" v-else>No devices</div>
                    </div>
                    <div class="card-footer">
                        <div class="float-right">
                            <#--<button v-on:click="edit" class="btn btn-primary btn-sm">EDIT</button>-->
                            <button v-on:click="generate" class="btn btn-primary btn-sm">GENERATE CLIENT</button>
                            <#--<button v-on:click="downloadCertificates" class="btn btn-primary btn-sm">DOWNLOAD-->
                                <#--CERTIFICATES-->
                            <#--</button>-->
                                <div class="btn-group">
                                    <button type="button" class="btn btn-primary btn-sm dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                        DOWNLOAD CERTIFICATES
                                    </button>
                                    <div class="dropdown-menu">
                                        <button class="dropdown-item" type="button" v-on:click="downloadCertificatesAsZip">.zip</button>
                                        <span title="Might have some issues with popup"><button class="dropdown-item" type="button" v-on:click="downloadCertificates">files</button></span>
                                        <div class="dropdown-divider"></div>
                                        <button class="dropdown-item" type="button" v-on:click="downloadRootCA">rootCA</button>
                                    </div>
                                </div>
                            <button v-on:click="dashboard" class="btn btn-primary btn-sm">DASHBOARD</button>
                        </div>
                        <button v-on:click="deleteThing" class="btn btn-danger btn-sm float-left text-white"><i
                                class="fa fa-trash-o fa-lg"></i>DELETE
                            THING
                        </button>
                    </div>
                </div>
            </div>
        </div>
        <div class="row">
            <div class="col-md-12">
                <p>&nbsp;</p>
                <div class="card">
                    <div class="card-header">
                        Crons
                    </div>
                    <div class="card-body p-0">
                        <table class="table mb-0" v-if="crons.length">
                            <thead class="thead-light">
                                <tr>
                                    <th>Name</th>
                                    <th>Cron expression</th>
                                    <th>Desired state</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tr v-for="cron in crons">
                                <td>
                                    {{cron.cronName == '' ? '-----' : cron.cronName}}
                                </td>
                                <td>
                                    {{cron.cronExpression}}
                                </td>
                                <td>
                                    {{cron.desiredState}}
                                </td>
                                <td>
                                    <button class="btn btn-danger btn-sm text-white"
                                            v-on:click="deleteCron(cron)">Delete</button>
                                </td>
                            </tr>
                        </table>
                        <div v-else class="h3 pt-2 pb-2 text-center text-muted" v-else>No crons</div>
                    </div>
                    <div class="card-footer">
                        <input id="cronXml" type="hidden">
                        <button v-on:click="addCron" class="btn btn-sm btn-primary">ADD CRON</button>
                        <#--<button v-on:click="deleteCron(cron)" class="btn btn-sm btn-default">EDIT</button>-->
                    </div>
                </div>
            </div>
        </div>
        <div class="row pb-5">
            <div class="col-md-12">
                <p>&nbsp;</p>
                <div class="card">
                    <div class="card-header">
                        Rules
                    </div>
                    <div class="card-body p-0">
                        <table class="table mb-0" v-if="rules.length">
                            <thead class="thead-light">
                                <tr>
                                    <th>Name</th>
                                    <th>Description</th>
                                    <th>Actions</th>
                                    <th>Settings</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr v-for="(rule,idx) in rules">
                                    <td>
                                        {{rule.name}}
                                    </td>
                                    <td>
                                        {{rule.description == '' ? '-----' : rule.description}}
                                    </td>
                                    <td>
                                        <button class="btn btn-danger btn-sm text-white"
                                                v-on:click="deleteRule(rule, idx)">DELETE</button>
                                        <button class="btn btn-sm btn-default"
                                                v-on:click="editRuleModal(rule, idx)">EDIT</button>
                                    </td>
                                    <td>
                                    <div v-if="rule.snsAction">
                                        <a v-bind:href="'/rules/' + rule.type.toLowerCase() + '/' + rule.snsAction.id" class="btn btn-success btn-sm" role="button" aria-pressed="true">DETAILS</a>
                                    </div>
                                    <div v-if="rule.actuatorAction">
                                        <a v-bind:href="'/rules/' + rule.type.toLowerCase() + '/' + rule.actuatorAction.id" class="btn btn-success btn-sm" role="button" aria-pressed="true">DETAILS</a>
                                    </div>
                                        <#--<button v-on:click="" class="btn btn-sm btn-success">CHANGE</button>-->
                                    </td>
                                </tr>
                        </table>
                        <div v-else class="h3 pt-2 pb-2 text-center text-muted" v-else>No rules</div>
                    </div>
                    <div class="card-footer">
                        <button v-on:click="newRuleModal" class="btn btn-sm btn-primary">CREATE RULE</button>
                    </div>
                </div>
            </div>
        </div>
        <div class="row hidden hide" style="display: none;">
            <div class="col-md-6">
                <p>&nbsp;</p>
                <div class="card">
                    <div class="card-header">
                        Test Topics
                    </div>

                    <div class="card-body p-1">
                        <form>
                            <div class="form-group">
                                <label class="col-form-label" for="formGroupExampleInput">Topic Name</label>
                                <input v-model="testTopic" type="text" class="form-control" id="formGroupExampleInput"
                                       placeholder="/topic_name">
                            </div>
                            <div class="form-group">
                                <input type="text" class="form-control" v-model="payload" placeholder="payload">
                            </div>
                            <div class="form-group">
                                <button v-on:click="publish" class="btn btn-default" type="button">Publish</button>
                                <button v-on:click="subscribe" class="btn btn-default" type="button">Subscribe</button>
                            </div>
                        </form>
                        <div>
                            <pre class="p-1" v-for="s in subscribed">{{s}}</pre>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>
<#include "../modals/crud_device.ftl"/>
<#include "../modals/crud_cron.ftl"/>
<#include "../modals/generate.ftl"/>
<#include "../modals/crud_rule.ftl"/>
<#include "../modals/rule_if.ftl"/>
<#include "../modals/rule_then.ftl"/>
</div>

<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-cookie/1.4.1/jquery.cookie.js"></script>
<script src="/static/js/app.js"></script>
<script>
    // TODO: Cannot delete form item in device
    // TODO: Bug for device with no name; Validation needed
    var token = $.cookie("authorization");
    var userId = ${user.id};
    var thingId = ${thing.id};

    var app = new Vue({
        el: '#container-main',
        data: {
            subscribeHandle: null,
            subscribed: [],
            testTopic: "",
            payload: "",
            device: {},
            saveLoader: false,
            saveLoaderStorage: false,
            role: "",
            unit: {},
            thing: {},
            devices: [],
            rules: [],
            createDevice: {
                "deviceAttributes": []
            },
            createRule: {},
            ruleUpdate: false,
            ruleActionList: [],
            createSubscription: {},
            cttr: {},
            generateCode: "",
            generateMessage: "",
            cron: {},
            cronDevice: {},
            cronAttribute: {},
            cronExpression: "",
            cronAttributeValue: "",
            cronName: "",
            crons: [],
            storageEnabled: "",
            blocklyXmls: []
        },
        methods: {

            // mostly all methods related to thing actions
            "importThing": function () {
                //TODO
            },


            "deleteThing": function () {
                alert(thingId);
                if (confirm("Are you sure you want to delete thing?") && confirm("Are you really sure?")) {
                    $.ajax({
                        url: "/thing/delete/" + thingId,
                        "method": "DELETE",
                        success: function (data) {
                            alert('Thing deleted');
                            this.load();
                        }
                    });
                }
            },

            // mostly all methods related to rules
            "enableStorage": function () {
                var that = this;
                that.saveLoaderStorage = true;
                $.ajax({
                    url: "/rule/ddb/enable/" + thingId,
                    "method": "POST",
                    "data": {
                        enable: that.storageEnabled
                    },
                    success: function (data) {
                        // console.log(data);
                        that.saveLoaderStorage = false;
                        // alert("Storage settings updated!");
                    }
                });
            },

            "newRuleModal": function () {
                this.createRule = {
                    name: "",
                    description: "",
                    data: "",
                    condition: "",
                    action: "",
                    sns_topic: "",
                    subject: "",
                    message: "",
                    attribute:"",
                    newValue:"",
                    ruleIfXml:"",
                    interval: 15
                };
                this.ruleUpdate = false;
                $('#create_rule').modal('show');
            },


            "saveRule": function () {
                var that = this;
                that.saveLoader = true;
                var formData = {
                    "name": that.createRule.name,
                    "description": that.createRule.description,
                    "data": that.createRule.data,
                    "topic": that.createRule.topic,
                    "condition": that.createRule.condition,
                    "action": that.createRule.action,
                    "ruleIfXml": that.createRule.ruleIfXml
                };

                // send extra parameters according to the type of rule
                if (that.createRule.action == 'SNS') {
                    formData.sns_topic = that.createRule.sns_topic;
                    formData.subject = that.createRule.subject;
                    formData.message = that.createRule.message;
                    formData.interval = that.createRule.interval;
                } else if(that.createRule.action == 'Actuator') {
                    formData.attribute = that.createRule.attribute;
                    formData.newValue = that.createRule.newValue;
                }

                console.log(that.createRule.action);
                $.ajax({
                    "url": "/rule/" + that.createRule.action.toLowerCase() + "/create/" + thingId,
                    "method": "POST",
                    "data": formData,
                    success: function (data) {
                        if(data.success !== false) {
                            that.rules.push(data);
                        }
                        that.saveLoader = false;
                        $('#create_rule').modal('hide');
                    }
                });
            },

            "deleteRule": function (rule, idx) {
                var that = this;

                $.ajax({
                    "url": "/rule/" + rule.type.toLowerCase() + "/delete/" + rule.id,
                    "method": "DELETE",
                    "success": function (data) {
                        if(data.success === true) {
                            alert("Rule deleted!");
                            that.rules.splice(idx, 1);
                        }
                    }

                });
            },

            "editRuleModal": function (rule, idx) {
                var that = this;
                console.log(rule);
                // Load rule in createRule (to be attached to form modal)
                that.createRule = rule;
                // This is to update the rule in place and not push updated rule as new rule
                that.createRule.idx = idx;
                // Load form modal in update mode
                that.ruleUpdate = true;
                // Load XML of blockly for IF condition
                var blocklyIfXmlObject = this.blocklyXmls.find(function(blockly){
                    return blockly.blockId == rule.id;
                });
                if(typeof blocklyIfXmlObject  != 'undefined' && blocklyIfXmlObject) {
                    that.createRule.ruleIfXml = blocklyIfXmlObject.xml;
                }
                $('#create_rule').modal('show');
            },

            "updateRule": function () {
                var that = this;
                that.saveLoader = true;

                var data = {
                    "name": that.createRule.name,
                    "description": that.createRule.description,
                    "data": that.createRule.data,
                    "topic": that.createRule.topic,
                    "condition": that.createRule.condition,
                    "parentThing": thingId,
                    "ruleIfXml": that.createRule.ruleIfXml
                };

                $.ajax({
                    "url": "/rule/" + that.createRule.type.toLowerCase() + "/update/" + that.createRule.id,
                    "method": "PUT",
                    "data": data,
                    success: function (data) {
                        that.saveLoader = false;
                        // replace the Rule with updated rule
                        that.rules[that.createRule.idx] = data;
                        $('#create_rule').modal('hide');
                    }
                });
            },

            // mostly all methods related to actions on things and devices
            "generate": function () {
                $("#generate_code").modal('show');
                saveLoader = true;
                var that = this;
                $.ajax({
                    url: "/device/generate/" + thingId,
                    "method": "GET",
                    success: function (data) {
                        that.saveLoader = false;
                        that.generateCode = data.substr(0, data.search("{") - 1);
                        that.generateMessage = data.substr(data.search("{"));
                    }
                });
            },

            "copyToClipboard": function () {
                $("#shadow-message").select();
                document.execCommand("Copy");
            },

            "dashboard": function () {
                window.location = "/things/dashboard/" + thingId;
            },

            "downloadCertificates": function () {
                var that = this;
                var fileNames = ["certificate.crt", "private.key", "public.key"];
                fileNames.forEach(function (fileName) {
                    window.open("/thing/certificate/get/" + fileName + "/" + thingId, "_blank");
                });
            },

            "downloadCertificatesAsZip": function () {
                var that = this;
                window.open("/thing/certificate/zip/" + thingId, "_blank");
            },

            "downloadRootCA": function () {
                var that = this;
                window.open("/thing/certificate/get/" + "rootCA" + "/" + thingId, "_blank");
            },

            // pubsub
            "publish": function () {
                var that = this;
                $.ajax({
                    url: "/pubsub/publish",
                    "method": "POST",
                    "data": {
                        "topic": that.testTopic,
                        "payload": that.payload
                    },
                    success: function (data) {

                    }
                });
            },

            "subscribe": function () {
                try {
                    clearInterval(this.subscribeHandle);
                } catch (ex) {
                }
                var that = this;

                $.ajax({
                    url: "/pubsub/subscribe",
                    "method": "POST",
                    "data": {
                        "topic": that.testTopic
                    },
                    success: function (data) {

                    }
                });

                this.subscribeHandle = setInterval(function () {
                    $.ajax({
                        url: "/pubsub/messages",
                        "method": "POST",
                        "data": {
                            "topic": that.testTopic
                        },
                        success: function (data) {
                            if (data.length > 0) {
                                for (var i in data) {
                                    that.subscribed.push(JSON.stringify(data[i], null, 4));
                                }

                            }
                        }
                    });
                }, 8000);
            },

            // load required data
            "load": function () {
                var that = this;
                $.ajax({
                    url: "/thing/get/" + thingId,
                    success: function (data) {
                        that.thing = data;
                        that.unit = that.thing.parentUnit;
                        that.storageEnabled = data.storageEnabled;
                        $.ajax({
                            url: "/unit/rights/" + that.unit.id + "/" + userId,
                            success: function (data) {
                                that.role = data[0].role;
                            }
                        });
                    }
                });

                $.ajax({
                    url: "/device/thing/" + thingId,
                    success: function (data) {
                        that.devices = data;
                    }
                });
                $.ajax({
                    url: "/rule/sns/thing/" + thingId,
                    success: function (data) {
                        that.rules = data;
                    }
                });
                $.ajax({
                    url: "/rule/actuator/thing/" + thingId,
                    success: function (data) {
                        that.rules = data;
                    }
                });
                $.ajax({
                    url: "/rule/actuator/thing/" + thingId,
                    success: function (data) {
                        that.rules = data;
                    }
                });
                $.ajax({
                    url: "/rule/actuator/thing/" + thingId,
                    success: function (data) {
                        that.rules = data;
                    }
                });
                $.ajax({
                    url: "/blockly/thing/" + thingId,
                    success: function (data) {
                        that.blocklyXmls = data;
                    }
                });
                $.ajax({
                    url: "/rule/actions",
                    success: function(data) {
                        console.log(data);
                        that.ruleActionList = data;
                    }
                });
                that.getCrons();

            },

            // TODO: Clear all the inputs here
            "addCron": function () {
                $("#create_cron").modal('show');
                addBlocklyCron();
            },

            // "edit": function () {
            //
            // },

            "deleteCron": function (cron) {
                var that = this;
                if (confirm("Are you sure you want to delete this cron?")) {
                    $.ajax({
                        url: "/cron/delete/" + cron.id,
                        "method": "DELETE",
                        success: function (data) {
                            that.getCrons();
                        }
                    });

                }
            },

            "getCrons": function () {
                var that = this;
                $.ajax({
                    url: "/cron/thing/" + thingId,
                    "method": "GET",
                    success: function (data) {
                        that.crons = data;
                    }
                });
            },

            "saveCron": function () {
                var that = this;
                that.saveLoader = true;
                saveCronData(that, function() {
                    var desired = {};

                    desired["device" + that.cronDevice.id + "." + that.cronAttribute.id] = (that.cronAttribute.type === 'Integer' || that.cronAttribute.type === 'Boolean') ? parseInt(that.cronAttributeValue, 10) : that.cronAttributeValue;
                    if (that.cronAttribute.type === 'Double') {
                        desired["device" + that.cronDevice.id + "." + that.cronAttribute.id] = parseFloat(that.cronAttributeValue);
                    }

                    $.ajax({
                        url: "/cron/create",
                        "method": "POST",
                        "data": {
                            "name": that.cronName,
                            "thingId": thingId,
                            "cronExpression": that.cronExpression,
                            "desiredState": JSON.stringify(desired)
                        },
                        success: function (data) {
                            that.saveLoader = false;
                            $("#create_cron").modal('hide');
                            that.getCrons();
                        }
                    });
                });
            },

            "removeAttr": function (key) {
                if (key !== -1) {
                    array.splice(key, 1);
                }
            },

            "addAttr": function () {
                console.log('Inside addAttr');
                if (this.cttr.name && this.cttr.type) {
                    this.createDevice.deviceAttributes.push(Object.assign({}, this.cttr));
                }
            },

            "newDevice": function () {
                this.createDevice = {
                    deviceAttributes: []
                };
                $("#create_device").modal('show');
            },

            "deleteDevice": function (device) {
                alert(device.id);
                this.saveLoader = true;
                var that = this;

                if (confirm("Are you sure you want to delete device?") && confirm("Are you really sure?")) {
                    $.ajax({
                        url: "/device/delete/" + device.id,
                        "method": "DELETE",
                        success: function (data) {
                            that.saveLoader = false;
                            alert("Device deleted!");
                            //that.deleteDeviceAttributes(device.id);
                            that.load();
                        }
                    });
                }
            },

            "deleteDeviceAttributes": function (deviceId) {
                if (confirm("Are you sure you want to delete device?") && confirm("Are you really sure?")) {
                    $.ajax({
                        url: "/attribute/delete/" + deviceId,
                        "method": "DELETE",
                        success: function (data) {
                            alert('Device attributes deleted!');
                            this.load();
                        }
                    });
                }
            },

            "saveDevice": function () {
                var that = this;
                this.saveLoader = true;
                that.createDevice.ownerUnitId = that.thing.parentUnit.id;
                that.createDevice.parentThingId = that.thing.id;
                if (this.createDevice.id) {
                    $.ajax({
                        url: "/device/update/" + that.createDevice.id,
                        "method": "PUT",
                        data: that.createDevice,
                        success: function (data) {
                            that.saveLoader = false;
                            that.saveAttributes(data.id, that.createDevice.deviceAttributes);
                            that.load();
                            $("#create_device").modal("hide");
                        }
                    });
                } else {
                    $.ajax({
                        url: "/device/create",
                        data: that.createDevice,
                        "method": "POST",
                        success: function (data) {
                            that.saveLoader = false;
                            that.saveAttributes(data.id, that.createDevice.deviceAttributes);
                            that.load();
                            $("#create_device").modal("hide");
                        }
                    });
                }
            },

            "editDevice": function (device) {
                this.createDevice = device;
                $("#create_device").modal('show');
            },

            "saveAttributes": function (deviceId, attributes) {
                $.ajax({
                    "url": "/attribute/add/" + deviceId,
                    "method": "POST",
                    "data": JSON.stringify(attributes),
                    contentType: "application/json; charset=utf-8",
                    "success": function (data) {
                        that.saveLoader = false;
                        that.load();
                    }
                });
            },

            "saveUnit": function () {
                this.saveLoader = true;
                var that = this;
                if (!this.createUnit.id) {
                    that.createUnit.parentUnitId = unitId;
                    $.ajax({
                        "url": "/unit/create",
                        "method": "POST",
                        "data": that.createUnit,
                        "success": function (data) {
                            that.saveLoader = false;
                            $("#create_unit").modal('hide');

                            that.load();
                        }
                    });
                } else {
                    $.ajax({
                        "url": "/unit/update/" + unitId,
                        "method": "PUT",
                        "data": that.createUnit,
                        "success": function (data) {
                            that.saveLoader = false;
                            $("#create_unit").modal('hide');
                            that.load();
                        }
                    });
                }
            }
        },

        mounted: function () {
            this.load()
        }
    });
</script>
</body>
</html>
