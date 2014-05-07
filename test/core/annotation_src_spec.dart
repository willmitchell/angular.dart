library annotation_src_spec;

import 'package:angular/core/annotation_src.dart';
import 'dart:mirrors';
import '../_specs.dart';

var _SYMBOL_NAME = new RegExp('"([^@]*).*"');
_getName(VariableMirror v) => _SYMBOL_NAME.firstMatch(v.simpleName.toString()).group(1);

Map<String, dynamic> variables(x) {
  Map variables = {};
  InstanceMirror mirror = reflect(x);
  ClassMirror type = mirror.type;
  do {
    type.declarations.forEach((k,v) {
      if (v is VariableMirror && !v.isStatic) {
        variables[_getName(v)] = mirror.getField(v.simpleName).reflectee;
      }
    });
  } while ((type = type.superclass) != null);

  return variables;
}

List<String> nullFields(x) {
  var ret = [];
  variables(x).forEach((k, v) {
    if (v == null) ret.add(k);
  });
  return ret;
}

void main() => describe('annotations', () {
  describe('component', () {
    it('should set all fields on clone when all the fields are set', () {
      var component = new Component(
        template: '',
        templateUrl: '',
        cssUrl: [''],
        applyAuthorStyles: true,
        resetStyleInheritance: true,
        publishAs: '',
        module: (){},
        map: {},
        selector: '',
        visibility: ViewDirective.LOCAL_VISIBILITY,
        exportExpressions: [],
        exportExpressionAttrs: [],
        useShadowDom: true
      );

      // Check that no fields are null
      expect(nullFields(component)).toEqual([]);

      // Check that the clone is the same as the original.
      expect(variables(cloneWithNewMap(component, {}))).toEqual(variables(component));
    });
  });

  describe('decorator', () {
    it('should set all fields on clone when all the fields are set', () {
      var decorator = new Decorator(
          map: {},
          selector: '',
          module: (){},
          visibility: ViewDirective.LOCAL_VISIBILITY,
          exportExpressions: [],
          exportExpressionAttrs: []
      );

      // Check that no fields are null
      expect(nullFields(decorator)).toEqual([]);

      // Check that the clone is the same as the original.
      expect(variables(cloneWithNewMap(decorator, {}))).toEqual(variables(decorator));
    });
  });

  describe('template', () {
    it('should set all fields on clone when all the fields are set', () {
      var template = new Template(
          map: {},
          selector: '',
          module: (){},
          visibility: ViewDirective.LOCAL_VISIBILITY,
          exportExpressions: [],
          exportExpressionAttrs: []
      );

      // Check that no fields are null
      expect(nullFields(template)).toEqual([]);

      // Check that the clone is the same as the original.
      expect(variables(cloneWithNewMap(template, {}))).toEqual(variables(template));
    });
  });

  describe('controller', () {
    it('should set all fields on clone when all the fields are set', () {
      var controller = new Controller(
          publishAs: '',
          map: {},
          selector: '',
          module: (){},
          visibility: ViewDirective.LOCAL_VISIBILITY,
          exportExpressions: [],
          exportExpressionAttrs: []
      );

      // Check that no fields are null
      expect(nullFields(controller)).toEqual([]);

      // Check that the clone is the same as the original.
      expect(variables(cloneWithNewMap(controller, {}))).toEqual(variables(controller));
    });
  });
});
