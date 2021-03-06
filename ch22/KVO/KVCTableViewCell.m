//
//  KVCTableViewCell.m
//  Copyright (c) 2012 Rob Napier
//
//  This code is licensed under the MIT License:
//
//  Permission is hereby granted, free of charge, to any person obtaining a
//  copy of this software and associated documentation files (the "Software"),
//  to deal in the Software without restriction, including without limitation
//  the rights to use, copy, modify, merge, publish, distribute, sublicense,
//  and/or sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
//  DEALINGS IN THE SOFTWARE.
//

#import "KVCTableViewCell.h"

@implementation KVCTableViewCell

- (BOOL)isReady {
  return (self.object && [self.property length] > 0);
}

- (void)update {
  self.textLabel.text = self.isReady ?
  [[self.object valueForKeyPath:self.property] description]
  : @"";
}

- (id)initWithReuseIdentifier:(NSString *)identifier {
  return [super initWithStyle:UITableViewCellStyleDefault
              reuseIdentifier:identifier];
}

- (void)removeObservation {
  if (self.isReady) {
    [self.object removeObserver:self
                     forKeyPath:self.property];
  }
}

- (void)addObservation {
  if (self.isReady) {
    [self.object addObserver:self forKeyPath:self.property
                     options:0 
                     context:(__bridge void*)self];
  }
}

- (void)observeValueForKeyPath:(NSString *)keyPath 
                      ofObject:(id)object 
                        change:(NSDictionary *)change 
                       context:(void *)context {
  if ((__bridge id)context == self) {
    // Our notification, not our superclass’s
      [self update];
  }
  else {
    [super observeValueForKeyPath:keyPath ofObject:object 
                           change:change context:context];
  }
}

- (void)dealloc {
  if (_object && [_property length] > 0) {
    [_object removeObserver:self forKeyPath:_property];
  }
}

- (void)setObject:(id)anObject {
  [self removeObservation];
  _object = anObject;
  [self addObservation];
  [self update];
}

- (void)setProperty:(NSString *)aProperty {
  [self removeObservation];
  _property = aProperty;
  [self addObservation];
  [self update];
}
@end