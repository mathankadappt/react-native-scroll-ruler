import PropTypes from "prop-types";
import React, { Component } from "react";
import { requireNativeComponent, View, ViewPropTypes } from "react-native";

type PropsType = {
  minValue?: number,
  maxValue?: number,
  defaultValue?: number,
  step?: number,
  num?: number,
  accessbilityText?:string,
  unit?: string
} & typeof View;

export default class ReactScrollRuler extends Component {
  static propTypes = {
    minValue: PropTypes.number.isRequired,
    maxValue: PropTypes.number.isRequired,
    defaultValue: PropTypes.number.isRequired,
    step: PropTypes.number.isRequired,
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
      defaultValue,
      step,
      num,
      unit,
      onSelect,
      isTime,
      markerTextColor,
      markerColor,
      accessbilityText,
      fontFamily,
      ...otherProps
    } = this.props;

    return (
      <RNScrollRuler
        ref={component => {
          this.rulerRef = component;
        }}
        minValue={minValue}
        maxValue={maxValue}
        defaultValue={defaultValue}
        step={step}
        num={num}
        unit={unit}
        onSelect={this._onSelect}
        isTime={isTime}
        markerTextColor={markerTextColor}
        markerColor={markerColor}
        accessbilityText={this.accessbilityText}
        fontFamily ={fontFamily}
        {...otherProps}
      />
    );
  }
}

const RNScrollRuler = requireNativeComponent(
  "RNScrollRuler",
  ReactScrollRuler,
  {
    nativeOnly: { onSelect: true }
  }
);
