// ==UserScript==
// @name         校园网自动登录脚本
// @namespace    http://tampermonkey.net/
// @version      1.0
// @description  自动登录cuit校园网
// @author       NanShanFish
// @match        http://10.254.241.19/eportal/index.jsp?*
// @grant        GM_setValue
// @grant        GM_getValue
// @grant        GM_registerMenuCommand
// @grant        GM_notification
// ==/UserScript==

(function() {
    'use strict';

    // 配置存储键名
    const CONFIG_KEY = 'cuit_net_config';

    // 默认配置
    const defaultConfig = {
        username: '',
        password: '',
        service: '',
        remember: false,
        autoconnect: false
    };

    // 获取当前配置
    function getConfig() {
        const savedConfig = GM_getValue(CONFIG_KEY, JSON.stringify(defaultConfig));
        return JSON.parse(savedConfig);
    }

    // 保存配置
    function saveConfig(config) {
        GM_setValue(CONFIG_KEY, JSON.stringify(config));
    }

    // 显示配置界面
    function showConfigDialog() {
        const config = getConfig();

        const html = `
        <div style="font-family: Arial, sans-serif; padding: 20px; background: white; border-radius: 5px; box-shadow: 0 0 10px rgba(0,0,0,0.3); position: fixed; top: 50%; left: 50%; transform: translate(-50%, -50%); z-index: 9999;">
            <h2 style="margin-top: 0;">校园网自动登录配置</h2>
            <div style="margin-bottom: 15px;">
                <label style="display: block; margin-bottom: 5px;">用户名:</label>
                <input type="text" id="config-username" value="${config.username}" style="width: 100%; padding: 8px; box-sizing: border-box;">
            </div>
            <div style="margin-bottom: 15px;">
                <label style="display: block; margin-bottom: 5px;">密码:</label>
                <input type="password" id="config-password" value="${config.password}" style="width: 100%; padding: 8px; box-sizing: border-box;">
            </div>
            <div style="margin-bottom: 15px;">
                <label style="display: block; margin-bottom: 5px;">服务类型:</label>
                <select id="config-service" style="width: 100%; padding: 8px; box-sizing: border-box;">
                    <option value="教育网" ${config.service === '教育网' ? 'selected' : ''}>教育网</option>
                    <option value="联通" ${config.service === '联通' ? 'selected' : ''}>联通</option>
                    <option value="移动" ${config.service === '移动' ? 'selected' : ''}>移动</option>
                    <option value="电信" ${config.service === '电信' ? 'selected' : ''}>电信</option>
                </select>
            </div>
            <div style="margin-bottom: 15px;">
                <label style="display: inline-block; margin-right: 15px;">
                    <input type="checkbox" id="config-remember" ${config.remember ? 'checked' : ''}> 记住密码
                </label>
                <label style="display: inline-block;">
                    <input type="checkbox" id="config-autoconnect" ${config.autoconnect ? 'checked' : ''}> 自动连接
                </label>
            </div>
            <div style="text-align: right;">
                <button id="config-save" style="padding: 8px 15px; background: #4CAF50; color: white; border: none; border-radius: 3px; cursor: pointer;">保存</button>
                <button id="config-cancel" style="padding: 8px 15px; margin-left: 10px; background: #f44336; color: white; border: none; border-radius: 3px; cursor: pointer;">取消</button>
            </div>
        </div>
        <div style="position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); z-index: 9998;"></div>
        `;

        const div = document.createElement('div');
        div.innerHTML = html;
        document.body.appendChild(div);

        document.getElementById('config-save').addEventListener('click', function() {
            const newConfig = {
                username: document.getElementById('config-username').value,
                password: document.getElementById('config-password').value,
                service: document.getElementById('config-service').value,
                remember: document.getElementById('config-remember').checked,
                autoconnect: document.getElementById('config-autoconnect').checked
            };

            saveConfig(newConfig);
            div.remove();
            GM_notification({text: '配置已保存！', title: '校园网自动登录'});
        });

        document.getElementById('config-cancel').addEventListener('click', function() {
            div.remove();
        });
    }

    // 注册菜单命令
    GM_registerMenuCommand('配置校园网自动登录', showConfigDialog);

    // 自动登录函数
    function autoLogin() {
        const config = getConfig();

        // 检查是否已配置
        if (!config.username || !config.password) {
            console.log('未配置用户名和密码，请先配置');
            return;
        }

        // 填写用户名
        const usernameInput = document.getElementById('username');
        if (usernameInput) {
            usernameInput.value = config.username;

            // 触发输入事件
            const event = new Event('input', { bubbles: true });
            usernameInput.dispatchEvent(event);
        }

        // 填写密码
        const passwordInput = document.getElementById('pwd');
        if (passwordInput) {
            passwordInput.value = config.password;

            // 触发输入事件
            const event = new Event('input', { bubbles: true });
            passwordInput.dispatchEvent(event);
        }

        // 选择服务
        const serviceSelect = document.getElementById('net_access_type');
        if (serviceSelect) {
            serviceSelect.value = config.service;

            // 更新显示文本
            const displayElement = document.getElementById('selectDisname');
            if (displayElement) {
                displayElement.textContent = config.service;
            }
        }

        // 勾选记住密码
        if (config.remember) {
            const rememberCheck = document.getElementById('disPlayIs_check_no');
            if (rememberCheck && rememberCheck.style.display === 'none') {
                const rememberYes = document.getElementById('disPlayClearSave_yes');
                if (rememberYes && rememberYes.style.display === 'block') {
                    // 如果已经是记住状态，不需要操作
                } else {
                    // 点击切换为记住状态
                    const checkElement = document.getElementById('jizhummNo');
                    if (checkElement) {
                        checkElement.click();
                    }
                }
            }
        }

        // 勾选自动连接
        if (config.autoconnect) {
            const autoConnectCheck = document.getElementById('disPlayIs_tj_no');
            if (autoConnectCheck && autoConnectCheck.style.display === 'block') {
                const autoConnectElement = document.getElementById('tjNoA');
                if (autoConnectElement) {
                    autoConnectElement.click();
                }
            }
        }

        // 点击登录按钮
        setTimeout(() => {
            const loginButton = document.getElementById('loginLink');
            if (loginButton) {
                loginButton.click();
                console.log('正在尝试自动登录...');
            }
        }, 1000);
    }

    // 页面加载完成后执行自动登录
    window.addEventListener('load', function() {
        // 等待页面完全加载
        setTimeout(autoLogin, 2000);
    });
})();
