(function() {

  jQuery.widget('toolstrap.toolstrapTooltip', {
    _create: function() {
      var _this = this;
      this.target = this.element.next('.tooltip');
      return this.element.on('hover', function() {
        _this.element.trigger('show');
        console.log(_this);
        return _this._position(_this.element, _this.target);
      });
    },
    _position: function(trigger, target) {
      var offset, placement;
      offset = target.css('margin');
      placement = (function() {
        switch (trigger.data('placement')) {
          case 'top':
            return {
              'my': 'bottom',
              'at': 'top',
              'offset': "0 -" + offset,
              'of': trigger
            };
          case 'right':
            return {
              'my': 'left',
              'at': 'right',
              'offset': "" + offset + " 0",
              'of': trigger
            };
          case 'bottom':
            return {
              'my': 'top',
              'at': 'bottom',
              'offset': "0 " + offset,
              'of': trigger
            };
          case 'left':
            return {
              'my': 'right',
              'at': 'left',
              'offset': "-" + offset + " 0",
              'of': trigger
            };
        }
      })();
      return target.position(placement);
    }
  });

}).call(this);
