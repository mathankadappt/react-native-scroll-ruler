import React, { Component } from "react";
import PropTypes from "prop-types";
import { requireNativeComponent, View, ViewPropTypes } from "react-native";

type PropsType = {
  minValue?: number,
  maxValue?: number,
  step?: number,
  defaultValue?: number,
  num?: number,
  accessbilityText?:string,
  unit?: string
} & typeof View;

export default class RNScrollRuler extends Component {
  static propTypes = {
    minValue: PropTypes.number.isRequired,
    maxValue: PropTypes.number.isRequired,
    step: PropTypes.number.isRequired,
    defaultValue: PropTypes.number.isRequired,
    num: PropTypes.number.isRequired,
    unit: PropTypes.string,
    accessbilityText: PropTypes.string,
    fontFamily: PropTypes.string,
    onSelect: PropTypes.func,
    ...ViewPropTypes
  };
  props: PropsType;
  rulerRef: any;

  setNativeProps(props: PropsType) {
    this.rulerRef.setNativeProps(props);
  }

  _onSelect = event => {
    if (!this.props.onSelect) {
      return;
    }
    this.props.onSelect(event.nativeEvent.value);
  };

  render() {
    const {
      minValue,
      maxValue,
      step,
      defaultValue,
      num,
      unit,
      onSelect,
      isTime,
      accessbilityText,
      fontFamily,
      ...otherProps
    } = this.props;

    
    return (
      <RCTScrollRuler
        ref={component => {
          this.rulerRef = component;
        }}
        minValue={minValue}
        maxValue={maxValue}
        step={step}
        defaultValue={defaultValue}
        num={num}
        unit={unit}
        isTime={isTime}
        fontFamily={fontFamily}
        onSelect={this._onSelect}
        accessbilityText={accessbilityText}
        {...otherProps}
      />
    );
  }
}

const RCTScrollRuler = requireNativeComponent("RCTScrollRuler", null);
