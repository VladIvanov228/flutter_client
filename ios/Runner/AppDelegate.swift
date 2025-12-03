/**
 * @openapi
 * /ios/Runner/AppDelegate.swift:
 *   get:
 *     summary: Получить точку входа iOS приложения
 *     description: |
 *       AppDelegate - главный класс, управляющий жизненным циклом iOS приложения.
 *       Отвечает за инициализацию Flutter Engine и регистрацию плагинов.
 *     tags:
 *       - Application
 *       - Lifecycle
 *       - Flutter
 *     responses:
 *       200:
 *         description: Успешное получение AppDelegate
 *         content:
 *           application/swift:
 *             schema:
 *               $ref: '#/components/schemas/AppDelegate'
 */

import UIKit
import Flutter

/**
 * @openapi
 * components:
 *   schemas:
 *     AppDelegate:
 *       type: object
 *       description: Главный делегат iOS приложения
 *       properties:
 *         className:
 *           type: string
 *           example: "AppDelegate"
 *           description: Имя класса делегата
 *         inheritance:
 *           type: string
 *           example: "FlutterAppDelegate"
 *           description: Родительский класс (FlutterAppDelegate)
 *         isMainEntry:
 *           type: boolean
 *           example: true
 *           description: Является ли точкой входа приложения
 *         lifecycleMethods:
 *           type: array
 *           items:
 *             $ref: '#/components/schemas/LifecycleMethod'
 */

@UIApplicationMain

/**
 * @openapi
 * components:
 *   schemas:
 *     LifecycleMethod:
 *       type: object
 *       description: Метод жизненного цикла приложения
 *       properties:
 *         name:
 *           type: string
 *           example: "application(_:didFinishLaunchingWithOptions:)"
 *           description: Сигнатура метода
 *         returnType:
 *           type: string
 *           example: "Bool"
 *           description: Тип возвращаемого значения
 *         parameters:
 *           type: array
 *           items:
 *             type: object
 *             properties:
 *               name:
 *                 type: string
 *                 example: "application"
 *               type:
 *                 type: string
 *                 example: "UIApplication"
 *         purpose:
 *           type: string
 *           example: "Инициализация приложения при запуске"
 * 
 *   responses:
 *     AppLaunchResponse:
 *       description: Ответ при запуске приложения
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               success:
 *                 type: boolean
 *                 example: true
 *                 description: Успешная инициализация
 *               pluginsRegistered:
 *                 type: integer
 *                 example: 5
 *                 description: Количество зарегистрированных плагинов
 */
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
  /**
     * @openapi
     * components:
     *   schemas:
     *     PluginRegistration:
     *       type: object
     *       description: Регистрация Flutter плагинов
     *       properties:
     *         method:
     *           type: string
     *           example: "GeneratedPluginRegistrant.register(with: self)"
     *           description: Метод регистрации плагинов
     *         source:
     *           type: string
     *           example: "Generated"
     *           description: Источник генерации (автоматический)
     *         timing:
     *           type: string
     *           enum: [launch, lazy]
     *           default: "launch"
     *           description: Время регистрации плагинов
     */
    GeneratedPluginRegistrant.register(with: self)

    /**
     * @openapi
     * components:
     *   schemas:
     *     SuperCall:
     *       type: object
     *       description: Вызов родительской реализации
     *       properties:
     *         method:
     *           type: string
     *           example: "super.application(application, didFinishLaunchingWithOptions: launchOptions)"
     *           description: Вызов метода суперкласса
     *         purpose:
     *           type: string
     *           example: "Сохранение стандартного поведения FlutterAppDelegate"
     */
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
