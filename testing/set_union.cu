#include <unittest/unittest.h>
#include <thrust/set_operations.h>
#include <thrust/functional.h>
#include <thrust/sort.h>
#include <thrust/iterator/discard_iterator.h>

template<typename Vector>
void TestSetUnionSimple(void)
{
  typedef typename Vector::iterator Iterator;

  Vector a(3), b(4);

  a[0] = 0; a[1] = 2; a[2] = 4;
  b[0] = 0; b[1] = 3; b[2] = 3; b[3] = 4;

  Vector ref(5);
  ref[0] = 0; ref[1] = 2; ref[2] = 3; ref[3] = 3; ref[4] = 4;

  Vector result(5);

  Iterator end = thrust::set_union(a.begin(), a.end(),
                                   b.begin(), b.end(),
                                   result.begin());

  ASSERT_EQUAL_QUIET(result.end(), end);
  ASSERT_EQUAL(ref, result);
}
DECLARE_VECTOR_UNITTEST(TestSetUnionSimple);


template<typename Vector>
void TestSetUnionWithEquivalentElementsSimple(void)
{
  typedef typename Vector::iterator Iterator;

  Vector a(3), b(5);

  a[0] = 0; a[1] = 2; a[2] = 2;
  b[0] = 0; b[1] = 2; b[2] = 2; b[3] = 2; b[4] = 3;

  Vector ref(5);
  ref[0] = 0; ref[1] = 2; ref[2] = 2; ref[3] = 2; ref[4] = 3;

  Vector result(5);

  Iterator end = thrust::set_union(a.begin(), a.end(),
                                   b.begin(), b.end(),
                                   result.begin());

  ASSERT_EQUAL_QUIET(result.end(), end);
  ASSERT_EQUAL(ref, result);
}
DECLARE_VECTOR_UNITTEST(TestSetUnionWithEquivalentElementsSimple);


template<typename T>
void TestSetUnion(const size_t n)
{
  thrust::host_vector<T> h_a = unittest::random_integers<T>(n);
  thrust::host_vector<T> h_b = unittest::random_integers<T>(n);

  thrust::stable_sort(h_a.begin(), h_a.end());
  thrust::stable_sort(h_b.begin(), h_b.end());

  thrust::device_vector<T> d_a = h_a;
  thrust::device_vector<T> d_b = h_b;

  thrust::host_vector<T>   h_result(h_a.size() + h_b.size());
  thrust::device_vector<T> d_result(d_a.size() + d_b.size());

  typename thrust::host_vector<T>::iterator h_end;
  typename thrust::device_vector<T>::iterator d_end;
  
  h_end = thrust::set_union(h_a.begin(), h_a.end(),
                            h_b.begin(), h_b.end(),
                            h_result.begin());
  h_result.resize(h_end - h_result.begin());

  d_end = thrust::set_union(d_a.begin(), d_a.end(),
                            d_b.begin(), d_b.end(),
                            d_result.begin());
  d_result.resize(d_end - d_result.begin());

  ASSERT_EQUAL(h_result, d_result);
}
DECLARE_VARIABLE_UNITTEST(TestSetUnion);

template<typename T>
void TestSetUnionToDiscardIterator(const size_t n)
{
  KNOWN_FAILURE;

//  thrust::host_vector<T> temp = unittest::random_integers<T>(2 * n);
//  thrust::host_vector<T> h_a(temp.begin(), temp.begin() + n);
//  thrust::host_vector<T> h_b(temp.begin() + n, temp.end());
//
//  thrust::sort(h_a.begin(), h_a.end());
//  thrust::sort(h_b.begin(), h_b.end());
//
//  thrust::device_vector<T> d_a = h_a;
//  thrust::device_vector<T> d_b = h_b;
//
//  thrust::discard_iterator<> h_result;
//  thrust::discard_iterator<> d_result;
//
//  // using host set_union here (instead of set_intersection)
//  // causes the device set_union below to throw an exception
//  // for no good reason afaict
//  thrust::host_vector<T> h_reference(2 * n);
//  typename thrust::host_vector<T>::iterator h_end = 
//    thrust::set_union(h_a.begin(), h_a.end(),
//                      h_b.begin(), h_b.end(),
//                      h_reference.begin());
//  h_reference.erase(h_end, h_reference.end());
//  
//  h_result = thrust::set_union(h_a.begin(), h_a.end(),
//                               h_b.begin(), h_b.end(),
//                               thrust::make_discard_iterator());
//
//  d_result = thrust::set_union(d_a.begin(), d_a.end(),
//                               d_b.begin(), d_b.end(),
//                               thrust::make_discard_iterator());
//
//  thrust::discard_iterator<> reference(h_reference.size());
//
//  ASSERT_EQUAL_QUIET(reference, h_result);
//  ASSERT_EQUAL_QUIET(reference, d_result);
}
DECLARE_VARIABLE_UNITTEST(TestSetUnionToDiscardIterator);


template<typename T>
  void TestSetUnionDescending(size_t n)
{
  thrust::host_vector<T> h_a = unittest::random_integers<T>(n);
  thrust::host_vector<T> h_b = unittest::random_integers<T>(n);

  thrust::stable_sort(h_a.begin(), h_a.end(), thrust::greater<T>());
  thrust::stable_sort(h_b.begin(), h_b.end(), thrust::greater<T>());

  thrust::device_vector<T> d_a = h_a;
  thrust::device_vector<T> d_b = h_b;

  thrust::host_vector<T>   h_result(h_a.size() + h_b.size());
  thrust::device_vector<T> d_result(d_a.size() + d_b.size());

  typename thrust::host_vector<T>::iterator h_end;
  typename thrust::device_vector<T>::iterator d_end;
  
  h_end = thrust::set_union(h_a.begin(), h_a.end(),
                            h_b.begin(), h_b.end(),
                            h_result.begin(),
                            thrust::greater<T>());
  h_result.erase(h_end, h_result.end());

  d_end = thrust::set_union(d_a.begin(), d_a.end(),
                            d_b.begin(), d_b.end(),
                            d_result.begin(),
                            thrust::greater<T>());
  d_result.erase(d_end, d_result.end());

  ASSERT_EQUAL(h_result, d_result);
}
DECLARE_VARIABLE_UNITTEST(TestSetUnionDescending);

