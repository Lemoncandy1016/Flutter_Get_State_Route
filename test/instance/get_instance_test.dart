import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'util/matcher.dart' as m;

class Mock {
  static Future<String> test() async {
    await Future.delayed(Duration.zero);
    return 'test';
  }
}

class DisposableController with GetLifeCycle {
  DisposableController() {
    initLifeCycle();
  }
}

// ignore: one_member_abstracts
abstract class Service {
  String post();
}

class Api implements Service {
  @override
  String post() {
    return 'test';
  }
}

void main() {
  test('Get.putAsync test', () async {
    await Get.putAsync<String>(Mock.test);
    expect('test', Get.find<String>());
    Get.reset();
  });

  test('Get.put test', () async {
    final instance = Get.put<Controller>(Controller());
    expect(instance, Get.find<Controller>());
    Get.reset();
  });

  test('Get start and delete called just one time', () async {
    Get..put(Controller())..put(Controller());

    final controller = Get.find<Controller>();
    expect(controller.init, 1);

    Get..delete<Controller>()..delete<Controller>();
    expect(controller.close, 1);
    Get.reset();
  });

  test('Get.put tag test', () async {
    final instance = Get.put<Controller>(Controller(), tag: 'one');
    final instance2 = Get.put<Controller>(Controller(), tag: 'two');
    expect(instance == instance2, false);
    expect(Get.find<Controller>(tag: 'one') == Get.find<Controller>(tag: 'two'),
        false);
    expect(Get.find<Controller>(tag: 'one') == Get.find<Controller>(tag: 'one'),
        true);
    expect(Get.find<Controller>(tag: 'two') == Get.find<Controller>(tag: 'two'),
        true);
    Get.reset();
  });

  test('Get.lazyPut tag test', () async {
    Get.lazyPut<Controller>(() => Controller(), tag: 'one');
    Get.lazyPut<Controller>(() => Controller(), tag: 'two');

    expect(Get.find<Controller>(tag: 'one') == Get.find<Controller>(tag: 'two'),
        false);
    expect(Get.find<Controller>(tag: 'one') == Get.find<Controller>(tag: 'one'),
        true);
    expect(Get.find<Controller>(tag: 'two') == Get.find<Controller>(tag: 'two'),
        true);
    Get.reset();
  });

  test('Get.lazyPut test', () async {
    final controller = Controller();
    Get.lazyPut<Controller>(() => controller);
    final ct1 = Get.find<Controller>();
    expect(ct1, controller);
    Get.reset();
  });

  test('Get.lazyPut with abstract class test', () async {
    final api = Api();
    Get.lazyPut<Service>(() => api);
    final ct1 = Get.find<Service>();
    expect(ct1, api);
    Get.reset();
  });

  test('Get.create with abstract class test', () async {
    Get.create<Service>(() => Api());
    final ct1 = Get.find<Service>();
    final ct2 = Get.find<Service>();
    expect(ct1 is Service, true);
    expect(ct2 is Service, true);
    expect(ct1 == ct2, false);
    Get.reset();
  });

  group('test put, delete and check onInit execution', () {
    tearDownAll(Get.reset);

    test('Get.put test with init check', () async {
      final instance = Get.put<DisposableController>(DisposableController());
      expect(instance, Get.find<DisposableController>());
      expect(instance.initialized, true);
    });

    test('Get.delete test with disposable controller', () async {
      expect(await Get.delete<DisposableController>(), true);
      expect(() => Get.find<DisposableController>(),
          throwsA(m.TypeMatcher<String>()));
    });

    test('Get.put test after delete with disposable controller and init check',
        () async {
      final instance = Get.put<DisposableController>(DisposableController());
      expect(instance, Get.find<DisposableController>());
      expect(instance.initialized, true);
    });
  });
}

class Controller extends DisposableController {
  int init = 0;
  int close = 0;
  @override
  void onInit() {
    init++;
    super.onInit();
  }

  @override
  void onClose() {
    close++;
    super.onClose();
  }
}
