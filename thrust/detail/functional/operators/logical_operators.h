/*
 *  Copyright 2008-2011 NVIDIA Corporation
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 */

#pragma once

#include <thrust/detail/config.h>
#include <thrust/detail/functional/actor.h>
#include <thrust/detail/functional/as_actor.h>
#include <thrust/detail/functional/composite.h>
#include <thrust/detail/functional/operators/operator_adaptors.h>
#include <thrust/functional.h>

namespace thrust
{
namespace detail
{
namespace functional
{

template<typename T1, typename T2>
__host__ __device__
actor<
  composite<
    binary_operator<thrust::logical_and>,
    typename as_actor<T1>::type,
    typename as_actor<T2>::type
  >
>
operator&&(const T1 &_1, const T2 &_2)
{
  return compose(binary_operator<thrust::logical_and>(),
                 as_actor<T1>::convert(_1),
                 as_actor<T2>::convert(_2));
} // end operator&&()

template<typename T1, typename T2>
__host__ __device__
actor<
  composite<
    binary_operator<thrust::logical_or>,
    typename as_actor<T1>::type,
    typename as_actor<T2>::type
  >
>
operator||(const T1 &_1, const T2 &_2)
{
  return compose(binary_operator<thrust::logical_or>(),
                 as_actor<T1>::convert(_1),
                 as_actor<T2>::convert(_2));
} // end operator&&()

template<typename Eval>
__host__ __device__
actor<
  composite<
    unary_operator<thrust::logical_not>,
    actor<Eval>
  >
>
operator!(const actor<Eval> &_1)
{
  return compose(unary_operator<thrust::logical_not>(), _1);
} // end operator!()

} // end functional
} // end detail
} // end thrust

