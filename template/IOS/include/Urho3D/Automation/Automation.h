//
// Copyright (c) 2008-2022 the Urho3D project.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//
#pragma once

#include "../Core/Object.h"
#include "../Input/Input.h"

#ifdef URHO3D_AUTOMATION
#include "../../ThirdParty/robot/Source/Robot.h"
#endif

namespace Urho3D
{

class URHO3D_API Automation : public Object
{
    URHO3D_OBJECT(Automation, Object);

public:
    Automation(Context* context);
    virtual ~Automation();
    bool IsAvaliable();
    void  MouseClick(MouseButton button) const;
    void  MousePress(MouseButton button) const;
    void  MouseRelease(MouseButton button) const;
    void  MouseScrollH(int amount) const;
    void  MouseScrollV(int amount) const;
    IntVector2  MouseGetPos(void);
    void  MouseSetPos(const IntVector2& point);
    void  MouseSetPos(uint32_t x, uint32_t y);
    bool  MouseGetState(MouseButton button);
    void  KeyboardClick(int keycode) const;
    void  KeyboardPress(int keycode) const;
    void  KeyboardRelease(int keycode) const;
    bool  KeyboardGetState(int keycode);
    IntRect GetScreenBounds();
private:
#ifdef URHO3D_AUTOMATION
    Robot::Mouse _mouse;
    Robot::Keyboard _keyboard;
#endif

};
} // namespace Urho3D
